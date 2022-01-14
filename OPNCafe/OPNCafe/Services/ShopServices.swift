//
//  ShopServices.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation


enum ServicePath : String {
    case storeInfo = "/storeInfo"
    case products = "/products"
    case makeOrder = "/order"
}

class ShopService:WebService {
    
    static func getShopInfo(completion:@escaping WebServiceCompletion<Shop>){
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = ServicePath.storeInfo.rawValue
        let url = urlBuilder.url!
        
        let task = WebService.create(url: url, requestType: .httpRequestGet, contentType: .json, header: nil, data: nil, completion: completion)
        
        task.resume()
    }
    
    
    static func getProductList(completion:@escaping WebServiceCompletion<[Product]>){
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = ServicePath.products.rawValue
        let url = urlBuilder.url!
        
        let task = WebService.create(url: url, requestType: .httpRequestGet, contentType: .json, header: nil, data: nil, completion: completion)
        
        task.resume()
    }
    
    
    static func makeOrder(order:Order, completion:@escaping WebServiceCompletion<NoResponse>){
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = ServicePath.makeOrder.rawValue
        let url = urlBuilder.url!
        
        
        let data:Dictionary<String, Any> = order.dictionary!
        
        let task = WebService.create(url: url, requestType: .httpRequestPost, contentType: .json, header: nil, data: data, expectedHttpResponse: 201, completion: completion)
        
        task.resume()
    }
    
    
}
