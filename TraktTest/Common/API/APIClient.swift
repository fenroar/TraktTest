//
//  APIClient.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import Alamofire

typealias Action = () -> ()
typealias SuccessAction = (_ response: Any) -> ()
typealias FailureAction = (_ statusCode: Int, _ error: Error?, _ responseBody: [String : AnyObject]?) -> ()

public enum APIError: Error {
    case invalidURL
}

final class APIClient {
    
    public static let shared = APIClient()
    
    public func service(_ service: URLRequestConvertible,
                        beforeAction: Action? = nil,
                        afterAction: Action? = nil,
                        success: @escaping SuccessAction,
                        failure: @escaping FailureAction) {
        
        if let before = beforeAction {
            before()
        }
        
        Alamofire.request(service).responseJSON { response in
            
            defer {
                
                if let after = afterAction {
                    after()
                }
            }
            
            switch response.result {
            case .success(let value):
                
                success(value)
                
            case .failure(let error):
                
                let statusCode = self.statusCodeFor(response)
                let responseBody = response.data?.serializeJSONToDictionary()
                
                failure(statusCode, error, responseBody)
            }
        }
    }
    
    public class func mutableRequestForURL(resourceURL: URL) -> URLRequest {
        
        var urlRequest = URLRequest(url: resourceURL,
                                    cachePolicy: .reloadIgnoringCacheData,
                                    timeoutInterval: APIConfiguration.timeoutInterval)
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("2", forHTTPHeaderField: "trakt-api-version")
        urlRequest.addValue(APIConfiguration.clientID, forHTTPHeaderField: "trakt-api-key")
        
        return urlRequest
    }
    
    private func statusCodeFor(_ response: DataResponse<Any>) -> Int {
        
        var statusCode = -1
        
        if let responseCode = response.response?.statusCode {
            statusCode = responseCode
        } else if let resultError = response.result.error as? NSError {
            statusCode = resultError.code
        }
        
        return statusCode
    }
}
