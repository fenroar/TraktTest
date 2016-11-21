//
//  TrendingMovie.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrendingMovie: Mappable {
    
    var watchers: Int?
    var movie: Movie?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        watchers        <- map["watchers"]
        movie           <- map["movie"]
    }
}
