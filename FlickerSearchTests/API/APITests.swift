//
//  APITests.swift
//  FlickerSearchTests
//
//  Created by RAJESH KUMAR on 06/07/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import XCTest
@testable import FlickerSearch

class APITests: XCTestCase {

    var viewController: SearchViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = SearchViewController()
        viewController.viewModel = SearchViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Search_Paginated_Response() {
        viewController.viewModel.paginationRes.bind { (response) in
            XCTAssertNotNil(response)
        }
        viewController.viewModel.search(searchText: "fruits")
    }
    
    func test_SearchAPIResponseTime() {
        let searchPhotoExpectation = expectation(description: "Expected the searh data to be loaded")
        let searchAPI = SearchAPI.searchPhotos(1, "fruits")
        APIManager.sharedInstance.request(searchAPI) { (value: SearchResponse?) in
            searchPhotoExpectation.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            print(error)
        }
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
