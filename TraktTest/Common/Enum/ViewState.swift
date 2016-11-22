//
//  ViewState.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation

public enum ViewState: Equatable {
    
    case none
    case fetching
    case complete
    case failure(message: String)
}

public func ==(lhs: ViewState, rhs: ViewState) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.fetching, .fetching):
        return true
    case (.complete, .complete):
        return true
    default:
        return false
    }
}
