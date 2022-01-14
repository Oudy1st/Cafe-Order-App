//
//  HomeViewModel.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation


public class MenuViewModel : BaseViewModel {
    
    let cafeInfo : Box<Shop?> = Box(nil)
    let productList : Box<[Product]?> = Box(nil)
    
    
    var order:Order? {
        get {
            if let orderProducts = self.productList.value?.filter({ product in
                product.total ?? 0 > 0
            }) {
                return Order.init(products: orderProducts)
            }
            else {
                return nil
            }
        }
    }
    
    override init() {
        super.init()
        //load shop info and set title
        self.showLoading()
        
        self.reloadShopInfo()
    }
    
    func hasOrder() -> Bool {
        if productList.value != nil {
            return productList.value!.first(where: { $0.total ?? 0 > 0 }) != nil
        }
        return false
    }
    
    func checkOrderSession()  {
        
        if let productList = self.productList.value {
            /// has order
            if OrderSession.shared.order.products.first(where: { $0.total ?? 0 > 0 }) != nil {
                // map product with order
                
                let orderProducts = OrderSession.shared.order.products
                
                for product in productList {
                    product.total = orderProducts.first(where: { $0.productId == product.productId })?.total ?? 0
                }
                
                self.productList.value = productList
            }
            else {
                /// no order = make sure all 0
                for product in productList {
                    product.total = 0
                }
                self.productList.value = productList
            }
        }
    }
    
}

/// services
extension MenuViewModel {
    
    func reloadShopInfo() {
        ShopService.getShopInfo { response, wsErrorType, error in
            self.hideLoading()
            if wsErrorType == .noError {
                self.cafeInfo.value = response
            }
            else {
                let errorAlert = ErrorAlert()
                errorAlert.message = error?.localizedDescription
                errorAlert.addAction(title: "Try Again", style: .cancel, handler: { _ in
                    self.reloadShopInfo()
                })
                
                self.errorAlert.value = errorAlert
            }
        }
    }
    
    func reloadProducts() {
        self.showLoading("loading")
        ShopService.getProductList{ response, wsErrorType, error in
            self.hideLoading()
            if wsErrorType == .noError {
                
                
                self.productList.value = response
                
                self.productList.value?.forEach({ product in
                    product.productId = NSUUID().uuidString
                    product.total = 0
                })
                
            }
            else {
            
                let errorAlert = ErrorAlert()
                errorAlert.message = error?.localizedDescription
                errorAlert.addAction(title: "Try Again", style: .cancel, handler: { _ in
                    self.reloadProducts()
                })
                
                self.errorAlert.value = errorAlert
            }
        }
    }
}
