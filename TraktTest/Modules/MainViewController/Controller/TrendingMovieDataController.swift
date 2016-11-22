//
//  TrendingMovieDataController.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol TrendingMovieDataControllerDelegate: class {
    
    func trendingMovieDataControllerStateDidChange(_ dataController: TrendingMovieDataController, state: ViewState)
    
    func trendingMovieDataControllerDataDidChange(_ dataController: TrendingMovieDataController)
    
    func trendingMovieDataController(_ dataController: TrendingMovieDataController, didSelectMovie movie: Movie)
}

internal enum TrendingMovieConstants {
    
    static let defaultPage = 1
}

class TrendingMovieDataController: NSObject {
    
    weak var delegate: TrendingMovieDataControllerDelegate?
    
    override init() {
        
    }
    
    var trendingMovies: [TrendingMovie] = []
    var currentPage = TrendingMovieConstants.defaultPage
    
    fileprivate var isFetching: ViewState = .none {
        didSet {
            self.delegate?.trendingMovieDataControllerStateDidChange(self, state: isFetching)
        }
    }
    
    public func fetchDataFromBeginning(completion: (() -> ())? = nil) {
        
        currentPage = TrendingMovieConstants.defaultPage
        isFetching = .none
        
        fetchDataForCurrentPage()
    }
    
    fileprivate func fetchDataForCurrentPage(completion: (() -> ())? = nil) {
        
        switch isFetching {
        case .none:
            performFetch(completion: completion)
        default:
            break
        }
    }
    
    private func performFetch(completion: (() -> ())? = nil) {
        
        isFetching = .fetching
        
        let service = MovieService.trending(page: currentPage)
        
        APIClient.shared.paginatedService(service, afterAction: {
            
            if let completion = completion {
                completion()
            }
            
            }, success: { [weak self] response, count in
                
                guard let strongSelf = self else {
                    return
                }
                
                if strongSelf.isFetching == .fetching {
                    strongSelf.isFetching = .none
                }
                
                if let trendingMovies = Mapper<TrendingMovie>().mapArray(JSONObject: response) {
                    
                    if strongSelf.currentPage == TrendingMovieConstants.defaultPage {
                        strongSelf.trendingMovies = trendingMovies
                    } else {
                        strongSelf.trendingMovies.append(contentsOf: trendingMovies)
                    }
                    
                    strongSelf.delegate?.trendingMovieDataControllerDataDidChange(strongSelf)
                    
                    strongSelf.currentPage += 1
                    
                    if count == strongSelf.currentPage {
                        strongSelf.isFetching = .complete
                    }
                }
                
        }) { [weak self] statusCode, error, responseBody in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.trendingMovieDataControllerDataDidChange(strongSelf)
            
            strongSelf.isFetching = .failure(message: error?.localizedDescription ?? "Unknown error")
        }
    }
    
    
}

extension TrendingMovieDataController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingMovieTableViewCell.cellName(), for: indexPath) as? TrendingMovieTableViewCell else {
            return UITableViewCell()
        }
        
        let trendingMovie = trendingMovies[indexPath.row]
        
        if let TMDBIdentifier = trendingMovie.movie?.tmdbID {
            
            cell.movieImageView.image = nil
            
            ImageCache.shared.downloadBackdropImageFor(TMDBIdentifier, completion: { image in
                cell.movieImageView.image = image
            })
            
        } else {
            cell.movieImageView.image = nil
        }
    
        cell.movieTitleLabel.text = trendingMovie.movie?.title ?? "No Title"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == trendingMovies.count - 1 {
            fetchDataForCurrentPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let trendingMovie = trendingMovies[indexPath.row]
        
        if let movie = trendingMovie.movie {
            self.delegate?.trendingMovieDataController(self, didSelectMovie: movie)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension TrendingMovieDataController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.isFetching != .fetching {
            self.isFetching = .none
        }
    }
}
