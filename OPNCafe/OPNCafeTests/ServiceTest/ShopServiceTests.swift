//
//  ShopServiceTest.swift
//  OPNCafeTests
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import XCTest
@testable import OPNCafe

class ShopServiceTests: XCTestCase {
    
    
    var exampleJSONData: Data!
    var order: Order!
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "OrderExample", withExtension: "json")!
        exampleJSONData = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        order = try! decoder.decode(Order.self, from: exampleJSONData)
    }
    
    func testGetShopDetail() {
        let expectation = self.expectation(description: "Shop Detail Results")
        
        ShopService.getShopInfo { response, wsErrorType, error in
            print(response ?? "no response")
            
            XCTAssertEqual(wsErrorType, .noError)
            
            
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetProducts() {
        let expectation = self.expectation(description: "Product Results")
        
        ShopService.getProductList { response, wsErrorType, error in
            print(response ?? "no response")
            
            XCTAssertEqual(wsErrorType, .noError)
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeOrder() {
        let expectation = self.expectation(description: "Make Order Results")
        
        ShopService.makeOrder(order: order, completion:{ response, wsErrorType, error in
            if error != nil {
                print("error : \(String(describing: error!.localizedDescription))")
            }
            else {
                print(response ?? "no response")
            }
            XCTAssertEqual(wsErrorType, .noError)
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 8, handler: nil)
    }
}
