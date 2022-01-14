//
//  Codable+Dict+Array.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation

extension Encodable {
    
    var dictionaryArray: [[String: Any]]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [[String: Any]] }
    }
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var isDictionaryable : Bool {
        guard let data = try? JSONEncoder().encode(self) else { return false }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) != nil
    }
    
    func copy<T:Codable>() -> T? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Dictionary {
    func toPostDataString() -> String {
        if self.keys.count > 0 {
            let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
            return  Array(self.keys.map({ "\($0)=\(String(describing: String(describing:self[$0]!).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!))"})).joined(separator: "&")
//            return  Array(self.keys.map({ "\($0)=\(String(describing:self[$0]!))"})).joined(separator: "&")
            
        }
        else
        {
            return ""
        }
    }
    func toGetDataString() -> String {
        if self.keys.count > 0 {
            let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
            return  Array(self.keys.map({ "\($0)=\(String(describing: String(describing:self[$0]!).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!))"})).joined(separator: "&")
            
        }
        else
        {
            return ""
        }
    }
    func toJsonString() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)!
        }
        else
        {
            return ""
        }
    }
}

extension Array where Element:Codable {
    func toJsonString(_ ignores:Any...) -> String {
        var array = [Dictionary<String, Any>]()
        for item in self {
            if let dic = item.dictionary {
                array.append(dic)
            }
        }
        
        return array.toJsonString()
    }
    
    func toDictionary(ignores:Any...) -> [Dictionary<String, Any>] {
        var array = [Dictionary<String, Any>]()
        for item in self {
            if let dic = item.dictionary {
                array.append(dic)
            }
        }
        
        return array
    }
}

extension Collection where Iterator.Element == Dictionary<String, Any>  {
    func toJsonString() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.fragmentsAllowed) {
            return String(data: jsonData, encoding: .utf8)!
        }
        else
        {
            return ""
        }
    }
    func toJsonData() -> Data {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.fragmentsAllowed) {
            return jsonData
        }
        else
        {
            return Data()
        }
    }
}
