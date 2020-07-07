//
//  ParameterEncoding.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 28/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest,
                with parameterS: Parameters) throws
}


public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlJsonEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest,
                                                 with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest,
                                                  with: bodyParameters)
            case .urlJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest,
                with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest,
                with: bodyParameters)
            }
            
        } catch {
            throw error
        }
    }
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
