//
//  ProductDataTest.swift
//  OPNCafeTests
//
//  Created by Detchat Boonpragob on 13/1/2565 BE.
//

import XCTest
@testable import OPNCafe

class ProductDataTests : XCTestCase {

    var exampleJSONData: Data!
    var data: [Product]!

    override func setUp() {
      let bundle = Bundle(for: type(of: self))
      let url = bundle.url(forResource: "ProductExample", withExtension: "json")!
      exampleJSONData = try! Data(contentsOf: url)
    
      let decoder = JSONDecoder()
        data = try! decoder.decode([Product].self, from: exampleJSONData)
    }
      
    func testDecodeNumberOfItem() throws {
        XCTAssertEqual(data.count, 2)
    }
    
    func testDecodeName() throws {
        XCTAssertEqual(data.first?.name, "Latte")
    }
    
    func testDecodePrice() throws {
        XCTAssertEqual(data.first?.price, 50)
    }
    
    func testDecodeImageUrl() throws {
        XCTAssertEqual(data.first?.imageUrl, "https://www.nespresso.com/ncp/res/uploads/recipes/nespresso-recipes-Latte-Art-Tulip.jpg")
    }
    
}
