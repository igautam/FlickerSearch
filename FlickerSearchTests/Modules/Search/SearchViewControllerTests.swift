//
//  SearchViewControllerTests.swift
//  FlickerSearchTests
//
//  Created by RAJESH KUMAR on 06/07/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import XCTest
@testable import FlickerSearch

class SearchViewControllerTests: XCTestCase {
    var viewController: SearchViewController!
    var photoCollectionView: UICollectionView!
    let dataSource = FakeDataSource()
    var cell: PhotoCollectionViewCell!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard
            .instantiateViewController(
                withIdentifier: "SearchViewController")
            as! SearchViewController
        
        
        viewController.loadViewIfNeeded()
        
        
        photoCollectionView = viewController.photoCollectionView
        photoCollectionView?.dataSource = dataSource
        
        cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: IndexPath(row: 0, section: 0)) as? PhotoCollectionViewCell
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_ControllerHasSeacrhBar() {
        if let searchBar = viewController.searchBar {
            XCTAssertTrue(searchBar.isDescendant(of: viewController.view))
        } else {
            XCTFail()
        }
    }
    
    func test_ControllerCollectionView() {
        if let photoCollectionView = viewController.photoCollectionView {
            XCTAssertTrue(photoCollectionView.isDescendant(of: viewController.view))
        } else {
            XCTFail()
        }
    }
    
    
    func test_CellHasPhotoImageView() {
        if let imageView = cell.photoImageView {
            XCTAssertTrue(imageView.isDescendant(of: cell.contentView))
        } else {
            XCTFail()
        }
    }
    
    func test_Search_Paginated_Response() {
        viewController.viewModel.paginationRes.bind { (response) in
            XCTAssertNotNil(response)
        }
        viewController.viewModel.search(searchText: "fruits")
    }
    
    func test_ImageDownload() {
        let photo: Photo = Photo(photoId: "50082223908", secret: "84bd5a5056", server: "65535", farm: 66)
        ImageDownloadManager.shared.downloadImage(photo, indexPath: photoCollectionView.indexPath(for: cell)) { (image, url, indexPathh, error) in
            XCTAssertTrue(type(of: image) == UIImage.self)
        }
    }
    func test_ImageDownloadResponseTime() {
        let downloadPhotoExpectation = expectation(description: "Expected the Photo to be loaded")
        let photo: Photo = Photo(photoId: "50082223908", secret: "84bd5a5056", server: "65535", farm: 66)
        ImageDownloadManager.shared.downloadImage(photo, indexPath: photoCollectionView.indexPath(for: cell)) { (image, url, indexPathh, error) in
            downloadPhotoExpectation.fulfill()
        }
        waitForExpectations(timeout: 3.0) { (error) in
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

extension SearchViewControllerTests {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            
        }
    }
}

extension SearchViewControllerTests: UISearchBarDelegate {
    class FakeSearhBarDelegate: NSObject, UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            guard let searchText = searchBar.text, searchText.count > 0 else {
                return
            }
        }
    }
}

