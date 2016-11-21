//
//  TMDBImageRequest.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias ImagesAction = (_ response: TMDBImageContainer) -> ()

class TMDBImageRequest {
    
    static let shared = TMDBImageRequest()
    
    private init() {
        
    }
    
    var imagesCache: [Int: TMDBImageContainer] = [:]
    
    func requestForTMDBId(_ TMDBId: Int, completion: @escaping ImagesAction) {
        
        let testAction: (_ identifier: Int, _ completion: @escaping ImagesAction) -> () = { id, completion in
            
            self.fetchImagesForTMDB(identifier: id, completion: completion)
        }
        
        if let images = imagesCache[TMDBId] {
            
            if images.backdrops.count > 0 || images.posters.count > 0 {
                completion(images)
            }
        } else {
            testAction(TMDBId, completion)
        }
        
    }
    
    private func fetchImagesForTMDB(identifier: Int, completion: @escaping ImagesAction) {
        
        self.imagesCache[identifier] = TMDBImageContainer(identifer: identifier)
        
        let myURL = buildImageRequestURLFor(identifier: identifier)
        
        Alamofire.request(myURL).responseJSON { [weak self] response in
            
            guard let strongSelf = self else {
                return
            }
            
            switch response.result {
            case .success(let value):
                
                if let imageContainer = Mapper<TMDBImageContainer>().map(JSONObject: value) {
                    strongSelf.imagesCache[identifier] = imageContainer
                    completion(imageContainer)
                }
                
            default:
                break
            }
        }
        
    }
    
    private func buildImageRequestURLFor(identifier: Int) -> URL {
        
        let urlPath = TMDBConfiguration.baseURL + "movie/\(identifier)/images?api_key=" + TMDBConfiguration.apiKey
        print(urlPath)
        return URL(string: urlPath)!
    }
}
