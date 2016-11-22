
//
//  ImageCache.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCache {
    
    let cache = NSCache<NSString, UIImage>()
    let downloader = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(),
                                     downloadPrioritization: .fifo,
                                     maximumActiveDownloads: 4,
                                     imageCache: AutoPurgingImageCache())
    
    static let shared = ImageCache()
    
    private init() {
        
    }
    
    func cacheImage(image: UIImage, key: String) {
        cache.setObject(image, forKey: (key as NSString))
    }
    
    func cachedImageFor(key: String) -> UIImage? {
        return cache.object(forKey: (key as NSString))
    }
    
    func downloadBackdropImageFor(_ tmdbID: Int, completion: @escaping (_ image: UIImage?) -> ()) {
        
        self.downloadImageFor(tmdbID, isBackdrop: true, completion: completion)
    }
    
    func downloadPosterImageFor(_ tmdbID: Int, completion: @escaping (_ image: UIImage?) -> ()) {
        
        self.downloadImageFor(tmdbID, isBackdrop: false, completion: completion)
    }
    
    private func downloadImageFor(_ tmdbID: Int, isBackdrop: Bool, completion: @escaping (_ image: UIImage?) -> ()) {
        
        TMDBImageRequest.shared.requestForTMDBId(tmdbID) { [weak self] container in
            
            // Get first image in backdrop or poster
            if let backdropFilePath = container.backdrops.first?.file_path,
                let posterFilePath = container.posters.first?.file_path {
                
                let filePath = isBackdrop ? backdropFilePath : posterFilePath
                
                if let cachedImage = ImageCache.shared.cachedImageFor(key: filePath) {
                    completion(cachedImage)
                } else {
                    completion(nil)
                    
                    if let imageURL = URL(string: TMDBConfiguration.imageURL + filePath) {
                        let request = URLRequest(url: imageURL)
                        
                        guard let strongSelf = self else {
                            return
                        }
                        
                        strongSelf.downloader.download(request, completion: { response in
                            
                            if let image = response.result.value {
                                // Cache the image
                                ImageCache.shared.cacheImage(image: image, key: filePath)
                                completion(image)
                            }
                        })
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
