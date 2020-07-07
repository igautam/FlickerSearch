//
//  SearchViewModel.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 28/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel {
    var paginationRes: Box<PaginationResponse?> = Box(nil)
    var error: Box<String?> = Box(nil)
    var photos: [Photo] = []
    let imageCache = NSCache<AnyObject, AnyObject>()
    var loadMore = false
    var currentPage = 1
    var searchText = ""
    let perPage = 20
    
    func search(searchText text: String) {
        self.searchText = text
        let searchAPI = SearchAPI.searchPhotos(currentPage, perPage,text)
        AppDelegate.delegate.showIndicatorView()
        APIManager.sharedInstance.request(searchAPI) { [weak self] (response: SearchResponse?, error) in
            AppDelegate.delegate.hideIndicatorView()
            if error == nil {
                if let resp = response {
                    if resp.photos.photo.count == 0 {
                        if let searchText = self?.searchText {
                            self?.error.value = "No Photos With Search Text \(searchText)"
                        } else {
                            self?.error.value = "No Photos With Search"
                        }
                    } else {
                        self?.paginationRes.value = PaginationResponse(page: resp.photos.page,
                                                                pages: resp.photos.pages,
                                                                perpage: resp.photos.perpage,
                                                                total: resp.photos.total)
                        self?.photos.append(contentsOf: resp.photos.photo)
                    }
                }
                self?.loadMore = false
            } else {
                self?.error.value = error
            }
        }
    }
    
    func loadMorePhotos() {
        if let pagination = paginationRes.value,
            let page = pagination?.page,
            let pages = pagination?.pages {
            if page < pages {
                currentPage += 1
                search(searchText: searchText)
            }
        }
    }
    
    func clearSearch() {
        self.paginationRes.value = nil
        self.photos.removeAll()
        self.loadMore = false
        self.currentPage = 1
        self.searchText = ""
    }
    
    func photoForIndex(index: Int) -> Photo? {
        if index < photos.count {
            return photos[index]
        }
        return nil
    }
}

//http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
