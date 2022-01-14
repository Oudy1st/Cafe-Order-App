//
//  SummaryViewModel.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import Foundation

public class SummaryViewModel : BaseViewModel {
    
    
    var order:Box<Order>!
    
    override init() {
        //load shop info and set title
        
        self.order = Box(OrderSession.shared.order)
    }
    
    
    func clearOrder()  {
        self.order?.bind(listener: nil)
        OrderSession.shared.resetOrder()
        self.order = Box(OrderSession.shared.order)
    }
}
