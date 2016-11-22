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
    var tagline: String?
    var overview: String?
    var released: String?
    var runtime: Int?
    var trailer: String?
    var homepage: String?
    var rating: Double?
    var votes: Int?
    var certification: String?
    var genres: [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title           <- map["title"]
        year            <- map["year"]
        trakt           <- map["ids.trakt"]
        slug            <- map["ids.slug"]
        imdbID          <- map["ids.imdb"]
        tmdbID          <- map["ids.tmdb"]
        
        tagline             <- map["tagline"]
        overview        <- map["overview"]
        released        <- map["released"]
        runtime         <- map["runtime"]
        trailer         <- map["trailer"]
        homepage        <- map["homepage"]
        rating          <- map["rating"]
        votes           <- map["votes"]
        certification   <- map["certification"]
        genres          <- map["genres"]
    }
}

extension Movie {
    
    func displayGenres() -> String {
        var displayText = ""
        
        if let genres = self.genres {
            for genre in genres {
                displayText.appendText(genre, separator: ", ")
            }
        }
        
        return displayText
    }
}
