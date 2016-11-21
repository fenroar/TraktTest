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
    var currentPage = 1
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateLabel()
        fetchTrending()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func handleNextPageTap(_ sender: Any) {
        
        fetchTrending()
    }
    
    func updateLabel() {
        displayLabel.text = "Fetched \(trendingMovies.count) movies"
    }
    
    public func fetchTrending() {
        
        APIClient.shared.service(MovieService.trending(page: currentPage), beforeAction: {
            
            self.nextPageButton.isEnabled = false
            
        }, afterAction: {
            
            self.nextPageButton.isEnabled = true
            self.updateLabel()
            
        }, success: {  [weak self] response, count in
            print(response)
            guard let strongSelf = self else {
                return
            }
            
            if let trendingMovies = Mapper<TrendingMovie>().mapArray(JSONObject: response) {
                strongSelf.trendingMovies.append(contentsOf: trendingMovies)
                strongSelf.currentPage += 1
            }
            
        }) { statusCode, error, responseBody in
            
            print(responseBody)
        }
    }
}

