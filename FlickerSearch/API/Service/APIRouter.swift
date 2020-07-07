//
//  EndPointType.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 28/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation

protocol APIRouter {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var baseURL: URL { get }
}

extension APIRouter {
    var apiKey: String {
      return ""
    }
}
