//
//  Order.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation


class Order: Codable {
    var products:[Product] = [Product]()
    var deliveryAddress:String = ""
    
    var total:Int {
        get {
            let total = products.reduce(0, { x, y in
                x + ((y.total ?? 0) * y.price)
            } )
            return total
        }
    }
    
    init(products:[Product], address:String = "") {
        self.products = products
        self.deliveryAddress = address
    }
    
    enum CodingKeys: String, CodingKey {
        case products = "products"
        case deliveryAddress = "delivery_address"
    }
}


