//
//  ViewController.swift
//  TraktTest
//
//  Created by Peter Su on 21/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

    var trendingMovies: [TrendingMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        APIClient.shared.service(MovieService.trending(), beforeAction: {
            
            print("Before")
            
        }, afterAction: {
            
            print("After")
        }, success: {  [weak self] response in
            print(response)
            guard let strongSelf = self else {
                return
            }
            
            if let trendingMovies = Mapper<TrendingMovie>().mapArray(JSONObject: response) {
                strongSelf.trendingMovies = trendingMovies
            }
            
        }) { statusCode, error, responseBody in
            
            print(responseBody)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

