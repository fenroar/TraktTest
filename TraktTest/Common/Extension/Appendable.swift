//
//  Appendable.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import Foundation

extension String {
    
    mutating func appendTextToNewLine(_ newText: String) {
        
        self.appendText(newText, separator: "\n\n")
    }
    
    mutating func appendText(_ newText: String, separator: String) {
        
        self = self.characters.count > 0 ? "\(self)\(separator)\(newText)" : newText
    }
}
