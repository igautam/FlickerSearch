//
//  FlickerSearchTests.swift
//  FlickerSearchTests
//
//  Created by RAJESH KUMAR on 04/07/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import XCTest
@testable import FlickerSearch

class FlickerSearchTests: XCTestCase {
    
    var viewController: SearchViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = SearchViewController()
        viewController.viewModel = SearchViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
