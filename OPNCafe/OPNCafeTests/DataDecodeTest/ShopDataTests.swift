//
//  dataTests.swift
//  OPNCafeTests
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import XCTest
@testable import OPNCafe

class ShopDataTests: XCTestCase {

    var exampleJSONData: Data!
    var data: Shop!

    override func setUp() {
      let bundle = Bundle(for: type(of: self))
      let url = bundle.url(forResource: "ShopExample", withExtension: "json")!
      exampleJSONData = try! Data(contentsOf: url)
    
      let decoder = JSONDecoder()
        data = try! decoder.decode(Shop.self, from: exampleJSONData)
    }
      
    func testDecodeName() throws {
        XCTAssertEqual(data.name, "The Coffee Shop")
    }
    
    func testDecodeRating() throws {
        XCTAssertEqual(data.rating, 4.5)
    }
    
    func testDecodeOpeningTime() throws {
      XCTAssertEqual(data.openingTime, "15:01:01.772Z")
    }
    
    func testDecodeClosingTime() throws {
        XCTAssertEqual(data.closingTime, "19:45:51.365Z")
    }
    


}
