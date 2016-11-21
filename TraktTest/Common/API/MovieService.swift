//
//  MovieService.swift
//  APITest
//
//  Created by Peter Su on 19/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import Alamofire

public enum MovieService: URLRequestConvertible {
    
    private static let rootPath = "movies/"
    
    case trending(page: Int)
    case detail(movieID: Int)
    case people(movieID: Int)
    
    private var requestProperties: (method: Alamofire.HTTPMethod, path: String, parameters: [String: Any]) {
        
        switch self {
        case .trending(let page):
            return (.get, "trending", ["page": page])
        case .detail(let movieID):
            return (.get, "\(movieID)", ["extended": "full"])
        case .people(let movieID):
            return (.get, "\(movieID)/people", [:])
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
     
        guard let baseURL = NSURL(string: APIConfiguration.url + MovieService.rootPath),
            let resourceURL = baseURL.appendingPathComponent(requestProperties.path) else {
                throw APIError.invalidURL
        }
        
        var request =  APIClient.mutableRequestForURL(resourceURL: resourceURL)
        request.httpMethod = requestProperties.method.rawValue
        
        return try Alamofire.JSONEncoding.default.encode(request, with: requestProperties.parameters)
    }
}
