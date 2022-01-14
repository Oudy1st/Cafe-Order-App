//
//  MenuData.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation

class Product : Codable {
    let name:String
    let price:Int
    let imageUrl:String
    
    var productId:String? = ""
    
    var total:Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price = "price"
        case imageUrl = "imageUrl"
        case productId = "productId"
        case total = "total"
    }
}
