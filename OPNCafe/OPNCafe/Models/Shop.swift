//
//  ShopData.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation


struct Shop : Decodable {
    let name:String
    let rating:Double
    let openingTime:String
    let closingTime:String
    
//    enum CodingKeys: String, CodingKey {
//      case name = "name"
//    }
}
