//
//  TMDBImageContainer.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import ObjectMapper

struct TMDBImageContainer: Mappable {
    
    var id: Int?
    var backdrops: [TMDBImage] = []
    var posters: [TMDBImage] = []
    
    init(identifer: Int) {
        self.id = identifer
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        backdrops       <- map["backdrops"]
        posters         <- map["posters"]
        id              <- map["id"]
    }
}

struct TMDBImage: Mappable {
    
    var aspect_ratio: Float?
    var file_path: String?
    var height: Float?
    var vote_average: Double?
    var vote_count: Int?
    var width: Float?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        aspect_ratio    <- map["aspect_ratio"]
        file_path       <- map["file_path"]
        height          <- map["height"]
        vote_average    <- map["vote_average"]
        vote_count      <- map["vote_count"]
        width           <- map["width"]
    }
}
