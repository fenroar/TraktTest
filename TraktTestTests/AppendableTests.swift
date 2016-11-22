//
//  AppendableTests.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import XCTest
import UIKit

@testable import TraktTest

class AppendableTests: XCTestCase {
    
    func testAppend() {
        
        var originalString = ""
        let separator = ", "
        
        originalString.appendText("Hello", separator: separator)

        XCTAssertTrue(originalString == "Hello")
        XCTAssertFalse(originalString == "Hello, ")
        
        originalString.appendText("Hello", separator: separator)
        
        XCTAssertTrue(originalString == "Hello" + separator + "Hello")
    }
    
}
