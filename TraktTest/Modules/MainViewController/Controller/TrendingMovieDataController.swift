//
//  TrendingMovieDataController.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ObjectMapper

protocol TrendingMovieDataControllerDelegate: class {
    
    func trendingMovieDataControllerDataDidChange(_ dataController: TrendingMovieDataController)
    
    func trendingMovieDataController(_ dataController: TrendingMovieDataController, didSelectMovie movie: TrendingMovie)
}

private enum TrendingMovieConstants {
    
    static let defaultPage = 1
}

private enum FetchState {
    
    case none
    case fetching
    case complete
}

class TrendingMovieDataController: NSObject {
    
    weak var delegate: TrendingMovieDataControllerDelegate?
    
    override init() {
        
    }
    
    var trendingMovies: [TrendingMovie] = []
    var currentPage = TrendingMovieConstants.defaultPage
    let downloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                     downloadPrioritization: .fifo,
                                     maximumActiveDownloads: 4,
                                     imageCache: AutoPurgingImageCache())
    
    private var isFetching: FetchState = .none
    
    public func fetchDataFromBeginning() {
        
        currentPage = TrendingMovieConstants.defaultPage
        isFetching = .none
        
        fetchDataForCurrentPage()
    }
    
    fileprivate func fetchDataForCurrentPage() {
        
        switch isFetching {
        case .none:
            performFetch()
        case .complete:
            print("Finished fetching everything")
        default:
            break
        }
    }
    
    private func performFetch() {
        
        isFetching = .fetching
        
        let service = MovieService.trending(page: currentPage)
        
        APIClient.shared.service(service, afterAction: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.isFetching != .complete {
                strongSelf.isFetching = .none
            }
            
            }, success: { [weak self] response, count in
                
                guard let strongSelf = self else {
                    return
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
            
            print("\(statusCode) - \(responseBody)")
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.trendingMovieDataControllerDataDidChange(strongSelf)
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
        
        if let TMDBIdentifier = trendingMovie.movie?.ids.tmdbID {
            
            cell.movieImageView.image = nil
            
            TMDBImageRequest.shared.requestForTMDBId(TMDBIdentifier) { [weak self] container in
                // Get first image in backdrop
                if let filePath = container.backdrops.first?.file_path {

                    if let backdropImage = ImageCache.shared.cachedImageFor(key: filePath) {
                        
                        cell.movieImageView.image = backdropImage
                    } else {
                        
                        cell.movieImageView.image = nil
                        
                        if let imageURL = URL(string: TMDBConfiguration.imageURL + filePath) {
                            let request = URLRequest(url: imageURL)
                            
                            self?.downloader.download(request, completion: { response in
                                
                                if let image = response.result.value {
                                    // Cache the image
                                    ImageCache.shared.cacheImage(image: image, key: filePath)
                                    cell.movieImageView.image = image
                                }
                            })
                        }
                    }
                } else {
                    cell.movieImageView.image = nil
                }
            }
        } else {
            cell.movieImageView.image = nil
        }
    
        cell.movieTitleLabel.text = trendingMovie.movie?.title ?? "No Title"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if indexPath.row == trendingMovies.count - 1 {
            fetchDataForCurrentPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let trendingMovie = trendingMovies[indexPath.row]
        self.delegate?.trendingMovieDataController(self, didSelectMovie: trendingMovie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
