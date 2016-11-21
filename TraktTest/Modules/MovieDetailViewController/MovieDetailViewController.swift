//
//  MovieDetailViewController.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit
import ObjectMapper

final class MovieDetailViewController: UIViewController {
    
    fileprivate let movieId: Int
    fileprivate var people: String = ""
    fileprivate var movie: Movie?
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    init(movieId: Int) {
        self.movieId = movieId
        
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadInformation()
    }
    
    func loadInformation() {
        
        let group = DispatchGroup()
        
        loadDetailsFor(group)
        loadPeopleFor(group)
        
        group.notify(queue: DispatchQueue.main) {
            print("All done")
            print(self.movie?.toJSON())
            
            if let tmdbID = self.movie?.tmdbID {
                
                ImageCache.shared.downloadPosterImageFor(tmdbID, completion: { image in
                    self.posterImageView.image = image
                })
            }
        }
    }
    
    func loadDetailsFor(_ group: DispatchGroup) {
        
        // movie has not been loaded
        if movie == nil {
            group.enter()
            
            let service = MovieService.detail(movieID: movieId)
            
            APIClient.shared.service(service, afterAction: {
                
                group.leave()
                
            }, success: { response in
                
                if let movie = Mapper<Movie>().map(JSONObject: response) {
                    self.movie = movie
                }
                
            }, failure: { statusCode, error, responseBody in
                
                print(error?.localizedDescription)
            })
        }
        
    }
    
    func loadPeopleFor(_ group: DispatchGroup) {
        
        if movie == nil {
            group.enter()
            
            let service = MovieService.people(movieID: movieId)
            
            APIClient.shared.service(service, afterAction: {
                
                group.leave()
                
            }, success: { response in
                
                if let responseDictionary = response as? Dictionary<String, Any>, let casts = responseDictionary["cast"] {
                    if let people = Mapper<Cast>().mapArray(JSONObject: casts) {
                        
                        print(people)
                        print(people.count)
                    }
                }
                
            }, failure: { statusCode, error, responseBody in
                
                print(error?.localizedDescription)
            })
        }
    }
    
    
}
