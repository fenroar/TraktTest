//
//  Movie.swift
//  APITest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import ObjectMapper

struct Movie: Mappable {
    
    var title: String?
    var year: Int?
    var ids: Ids
    
    init?(map: Map) {
        ids = Ids()
    }
    
    mutating func mapping(map: Map) {
        
        title           <- map["title"]
        year            <- map["year"]
        ids             <- map["ids"]
    }
}

struct Ids: Mappable {
    
    var trakt: Int?
    var slug: String?
    var imdbID: String?
    var tmdbID: Int?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        trakt           <- map["trakt"]
        slug            <- map["slug"]
        imdbID          <- map["imdb"]
        tmdbID          <- map["tmdb"]
    }
}
