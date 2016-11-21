//
//  Cast.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import ObjectMapper

struct Cast: Mappable {
    
    var character: String?
    var name: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        character       <- map["character"]
        name            <- map["person.name"]
    }
}
