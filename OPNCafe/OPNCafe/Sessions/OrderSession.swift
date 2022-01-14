//
//  OrderSession.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import UIKit


class OrderSession: NSObject {
    
    static let shared:OrderSession = OrderSession()
    
    var order = Order.init(products: [Product]())
    
    override init() {
        super.init()
    }

    
    func resetOrder() {
        self.order = Order.init(products: [Product]())
    }

}

