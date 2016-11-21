//
//  ImageCache.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit

class ImageCache {
    
    let cache = NSCache<NSString, UIImage>()
    
    static let shared = ImageCache()
    
    private init() {
        
    }
    
    func cacheImage(image: UIImage, key: String) {
        cache.setObject(image, forKey: (key as NSString))
    }
    
    func cachedImageFor(key: String) -> UIImage? {
        return cache.object(forKey: (key as NSString))
    }
}
