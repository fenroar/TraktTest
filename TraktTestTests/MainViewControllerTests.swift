//
//  MainViewControllerTests.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import XCTest
import UIKit

@testable import TraktTest

class MainViewControllerTests: XCTestCase {
    
    var viewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        let _ = viewController.view
    }
    
    func testFetch() {
        
        let expect = expectation(description: "Should fetch trending movies")
        
        viewController.refreshData {
            if self.viewController.dataController.trendingMovies.count > 0 {
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: APIConfiguration.timeoutInterval) { error in
            XCTAssertNil(error, "Test timed out. \(error?.localizedDescription)")
        }
    }
    
}
