//
//  SearchViewModelTests.swift
//  FlickerSearchTests
//
//  Created by RAJESH KUMAR on 07/07/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import XCTest
@testable import FlickerSearch

class SearchViewModelTests: XCTestCase {
    var searchViewModel = SearchViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_search() {
        searchViewModel.paginationRes.bind { (response) in
            XCTAssertNotNil(response)
        }
        searchViewModel.search(searchText: "fruits")
        test_ClearSearch()
    }

    func test_ClearSearch() {
        searchViewModel.clearSearch()
        XCTAssertTrue(searchViewModel.photos.count == 0)
    }
    
    func test_photoForIndexWithoutSearch() {
        let photo = searchViewModel.photoForIndex(index: 0)
        XCTAssertNil(photo)
    }
    
    func test_photoForIndexWithSearch() {
        searchViewModel.paginationRes.bind { (response) in
            XCTAssertNotNil(response)
            let photo = self.searchViewModel.photoForIndex(index: 0)
            XCTAssertTrue(photo?.photoId != "")
        }
        searchViewModel.search(searchText: "fruits")
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
