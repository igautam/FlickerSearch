//
//  SearchAPI.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 27/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation

enum SearchAPI: APIRouter {
    case searchPhotos(Int, Int, String)
    
    var baseURL: URL {
        switch self {
        case .searchPhotos(_, _, _):
            guard let url = URL(string: Environment.current.baseURL) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
    }
    
    var path: String {
        switch self {
        case .searchPhotos(_, _, _):
            return "/services/rest/"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .searchPhotos(let page, let perPage, let searchText):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "per_page": perPage,
                                                      "method": "flickr.photos.search",
                                                      "api_key":apiKey,
                                                      "nojsoncallback":"1",
                                                      "safe_search":"1",
                                                      "text":searchText,
                                                      "format": "json"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
