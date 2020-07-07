//
//  Environment.swift
//  iSeeMovies
//
//  Created by Tais on 7/4/18.
//  Copyright © 2018 Tais. All rights reserved.
//

import Foundation

enum Environment : String {
    
    case dev = "Development"
    case qual = "Test"
    case prod = "Production"
    
    static var current: Environment {
        if let value = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String,
            let env = Environment(rawValue: value) {
            return env
        }
        
        return .qual
    }
    
    var baseURL: String {
        //TODO::Remove below line used only for stub
        switch self {
        case .dev, .qual:
            return "https://api.flickr.com"
        case .prod:
            return "https://api.flickr.com"
        }
    }
    
    var pushNotificationsEnabled: Bool {
        switch self {
        case .dev, .qual:
            return true
        case .prod:
            return true
        }
    }
}
