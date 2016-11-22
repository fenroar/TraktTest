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
    fileprivate var movie: Movie
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var castCrewButton: UIButton!
    @IBOutlet weak var posterIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imageFailureView: UIView!
    
    var casts: [Cast] = []
    
    init(movie: Movie) {
        self.movieId = movie.trakt!
        self.movie = movie
        
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadInformation()
    }
    
    func loadInformation() {
        
        loadDetails()
        loadPeople()
    }
    
    func loadDetails() {

        if let tmdbID = self.movie.tmdbID {
            
            ImageCache.shared.downloadPosterImageFor(tmdbID, completion: { image in
                
                self.posterIndicatorView.stopAnimating()
                self.posterImageView.image = image
                
            }, failure: {
                
                self.posterIndicatorView.stopAnimating()
                self.imageFailureView.isHidden = false
            })
        }
    }
    
    func loadPeople() {
        
        let service = MovieService.people(movieID: movieId)
        
        APIClient.shared.service(service, success: { [weak self] response in
            
            if let responseDictionary = response as? Dictionary<String, Any>, let casts = responseDictionary["cast"] {
                
                if let people = Mapper<Cast>().mapArray(JSONObject: casts) {
                    self?.casts = people
                }
                
                self?.castCrewButton.isHidden = self?.casts.count == 0
            }
            
        }, failure: { statusCode, error, responseBody in
            
            print(error?.localizedDescription ?? "Unknown error")
        })
    }
}

extension MovieDetailViewController {
    
    public func populateView() {
        
        imageFailureView.isHidden = true
        imageFailureView.layer.borderWidth = 2.0
        imageFailureView.layer.borderColor = UIColor.white.cgColor
        
        castCrewButton.isHidden = casts.count == 0
        title = movie.title ?? "Movie Details"
        summaryLabel.text = movie.overview! + movie.overview! // ?? ""
        tagLineLabel.text = movie.tagline ?? ""
        informationLabel.text = buildInformationStringFor(movie)
    }
    
    private func buildInformationStringFor(_ movie: Movie) -> String {
        
        var displayString = ""
        
        if let runTime = movie.runtime {
            let runTimeString = "Runtime: \(runTime) minutes"
            displayString.appendTextToNewLine(runTimeString)
        }
        
        if let released = movie.released {
            let releaseDateString = "Release Date: \(released)"
            displayString.appendTextToNewLine(releaseDateString)
        }
        
        if let certification = movie.certification {
            let certificationString = "Certification: \(certification)"
            displayString.appendTextToNewLine(certificationString)
        }
        
        if let averageScore = movie.rating {
            
            let averageScoreString = String(format: "Score: %.02f / 10", averageScore)
            displayString.appendTextToNewLine(averageScoreString)
        }
        
        if let votes = movie.votes {
            let votesString = "Votes: \(votes)"
            displayString.appendTextToNewLine(votesString)
        }
        
        let votesString = "Genre: \(movie.displayGenres())"
        displayString.appendText(votesString, separator: "\n\n")
        
        return displayString
    }
}
