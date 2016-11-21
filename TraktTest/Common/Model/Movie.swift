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
    var trakt: Int?
    var slug: String?
    var imdbID: String?
    var tmdbID: Int?
    
    // Full movie details
    var tag: String?
    var overview: String?
    var released: String?
    var runtime: Int?
    var trailer: String?
    var homepage: String?
    var rating: Double?
    var votes: Int?
    var certification: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title           <- map["title"]
        year            <- map["year"]
        trakt           <- map["ids.trakt"]
        slug            <- map["ids.slug"]
        imdbID          <- map["ids.imdb"]
        tmdbID          <- map["ids.tmdb"]
        
        tag             <- map["tag"]
        overview        <- map["overview"]
        released        <- map["released"]
        runtime         <- map["runtime"]
        trailer         <- map["trailer"]
        homepage        <- map["homepage"]
        rating          <- map["rating"]
        votes           <- map["votes"]
        certification   <- map["certification"]
    }
}
