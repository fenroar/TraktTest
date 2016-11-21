//
//  MovieTests.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TraktTest

class MovieTests: XCTestCase {
    
    func testMapping() {
        
        let response = trendingMovieJSON()
        let trendingMovies = Mapper<TrendingMovie>().mapArray(JSONObject: response)
        
        let firstMovie = trendingMovies?.first!
        
        XCTAssertTrue(firstMovie?.watchers! == 1)
        XCTAssertTrue(firstMovie?.movie?.title! == "Movie 1")
        XCTAssertTrue(firstMovie?.movie?.year! == 2016)
        XCTAssertTrue(firstMovie?.movie?.ids.imdbID! == "imdbID")
        XCTAssertTrue(firstMovie?.movie?.ids.slug! == "Movie 1 slug")
        XCTAssertTrue(firstMovie?.movie?.ids.tmdbID! == 123456)
        XCTAssertTrue(firstMovie?.movie?.ids.trakt! == 654321)
    }
    
    func trendingMovieJSON() -> [[String: Any]] {
        return [["movie" : ["title": "Movie 1",
                            "year" : 2016,
                            "ids" : ["imdb" : "imdbID",
                                     "slug" : "Movie 1 slug",
                                     "tmdb" : 123456,
                                     "trakt": 654321 ]],
                "watchers" : 1]]
    }
    
    func testFetchTrendingWithExpection() {
        
        let expect = expectation(description: "Should fetch trending movies")
        
        APIClient.shared.service(MovieService.trending(), success: { response in
            
            let trendingMovies = Mapper<TrendingMovie>().mapArray(JSONObject: response)
            XCTAssertNotNil(trendingMovies, "Failed to map response")
            
            expect.fulfill()
            
        }) { (statusCode, error, responseBody) in
            XCTFail("API call failed: \(error?.localizedDescription)")
        }
        
        waitForExpectations(timeout: APIConfiguration.timeoutInterval) { error in
            XCTAssertNil(error, "Test timed out. \(error?.localizedDescription)")
        }
    }
    
}
