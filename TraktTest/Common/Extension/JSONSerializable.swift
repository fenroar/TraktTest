//
//  JSONSerializable.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation

public extension Data {
    
    public func serializeJSONToDictionary() -> [String: AnyObject]? {
        
        var responseBody: [String: AnyObject]?
        do {
            try responseBody = JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
        } catch {
            responseBody = nil
        }
        return responseBody
    }
}
