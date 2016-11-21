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
    
    case trending()
    
    private var requestProperties: (method: Alamofire.HTTPMethod, path: String, parameters: [String:AnyObject]) {
        
        switch self {
        case .trending():
            return (.get, "trending", [:])
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