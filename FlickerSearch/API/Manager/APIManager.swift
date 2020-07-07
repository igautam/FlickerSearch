//
//  APIManager.swift
//  iSeeMovies
//
//  Created by Tais on 7/4/18.
//  Copyright © 2018 Tais. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String> {
    case success
    case failure(String)
}

class APIManager {
    static var sharedInstance = APIManager()
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    private var task: URLSessionTask?
    fileprivate let queue = OperationQueue()
    fileprivate let group = DispatchGroup()
    var reqCount = 0
    var imageReqCount: Int = 0
    
    init() {
        queue.maxConcurrentOperationCount = 1
    }
}

extension APIManager {
    
    func request<T: Decodable>(_ route: APIRouter, withCompletion completion: @escaping (_ data: T?, _ error: String?) -> Void) {
        reqCount = reqCount + 1
        print("reqCount: \(reqCount)")
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                self?.group.leave()
                
                if error != nil {
                    completion(nil, "Please check your network connection.")
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self?.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let data = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        let wrapper = try? JSONDecoder().decode(T.self, from: data)
                        completion(wrapper, nil)
                    case .failure(let error):
                        completion(nil, error)
                    case .none:
                        completion(nil, NetworkResponse.failed.rawValue)
                    }
                }
            })
            
            queue.addOperation {
                self.group.enter()
                self.task?.resume()
                _ = self.group.wait(timeout: DispatchTime.distantFuture)
            }
            
        } catch {
            completion(nil, error.localizedDescription)
        }
    }
    
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    fileprivate func buildRequest(from route: APIRouter) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
