//
//  SearchModel.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 27/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var photos: Photos
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case status = "stat"
        
    }
}

struct Photos: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
        case photo = "photo"
    }
}

struct Photo: Decodable {
    var photoId: String
    var secret: String
    var server: String
    var farm: Int
    
    enum CodingKeys: String, CodingKey {
        case photoId = "id"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
    }

    func flickrImageURL() -> URL? {
        if let url = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(photoId)_\(secret).jpg") {
            return url
        }
        return nil
    }
}

struct PaginationResponse: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
}
