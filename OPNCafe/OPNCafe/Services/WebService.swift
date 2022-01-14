//
//  WebService.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation


enum HTTPRequestType : Int {
    case httpRequestGet,httpRequestPost,httpRequestPut
    func toKey() -> String! {
        switch self {
        case .httpRequestPost:
            return "POST"
        case .httpRequestGet:
            return "GET"
        case .httpRequestPut:
            return "PUT"
        }
    }
}

enum ContentType : Int {
    case form, json
    
    func toKey() -> String! {
        switch self {
        case .form:
            return "application/x-www-form-urlencoded"
        case .json:
            return "application/json"
        }
    }
}

enum WebServiceError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case noError
}

class NoResponse:Decodable {
    
}

class WebService {
    typealias WebServiceCompletion<T:Decodable> = (_ response:T?,_ wsErrorType:WebServiceError,_ error:Error?) -> Void
    
    static let host = "c8d92d0a-6233-4ef7-a229-5a91deb91ea1.mock.pstmn.io"
    
    static func create<T>(url:URL, requestType : HTTPRequestType , contentType : ContentType , header : Dictionary<String,String>? = nil, data : Dictionary<String,Any>?, expectedHttpResponse:Int = 200,completion :@escaping WebServiceCompletion<T> ) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.setValue(contentType.toKey(), forHTTPHeaderField: "Content-Type")
        request.httpMethod = requestType.toKey()
        
        
        if header != nil {
            for key in header!.keys {
                request.setValue(header![key]!, forHTTPHeaderField: key)
            }
        }
        
        if let bodyData = data {
            switch requestType {
            case .httpRequestGet:
                if let urlString = request.url?.absoluteString
                {
                    let newURL = "\(urlString)?\(String(describing: bodyData.toGetDataString()))"
                    request.url = URL(string: newURL)
                }
                break
            case .httpRequestPost,.httpRequestPut:
                var body:String?
                switch contentType {
                case .form:
                    body = bodyData.toPostDataString()
                    break
                case .json:
                    body = bodyData.toJsonString()
                    break
                }
                dump(body)
                request.httpBody = body?.data(using: .utf8)
                break
                
            }
        }
        
        let session = URLSession.shared;
        return session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    
                    completion(nil, .failedRequest, error)
                    return
                }
                
                
                guard let data = data else {
                    
                    let errorResponse = NSError(domain: "WS", code: 0, userInfo: [NSLocalizedDescriptionKey :"No Data"])
                    completion(nil, .noData, errorResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
//                    print("Unable to process response")
                    
                    let errorResponse = NSError(domain: "WS", code: 0, userInfo: [NSLocalizedDescriptionKey :"Unable to process response"])
                    
                    completion(nil, .invalidResponse, errorResponse)
                    return
                }
                
                guard response.statusCode == expectedHttpResponse else {
                    let errorResponse = NSError(domain: "WS", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey :"Http status code has unexpected value \(response.statusCode)"])
                    
                    completion(nil, .failedRequest, errorResponse)
                    return
                }
                
                if T.self == NoResponse.self {
                    completion(nil,.noError, nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let responseData: T = try decoder.decode(T.self, from: data)
                    completion(responseData,.noError, nil)
                } catch {
                    let errorResponse = NSError(domain: "WS", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey :"Unable to decode \(url.absoluteString) response: \(error.localizedDescription)"])
                    completion(nil, .invalidData, errorResponse)
                }
            }
        }
    }
}
