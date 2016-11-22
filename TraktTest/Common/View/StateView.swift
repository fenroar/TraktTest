//
//  StateView.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit

final class StateView: UIView {
    
    let diplayLabel = UILabel()
    private var edgeConstraints: [NSLayoutConstraint] = []
    
    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            
            edgeConstraints.forEach { $0.constant = padding }
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        self.isUserInteractionEnabled = false
        
        diplayLabel.numberOfLines = 0
        diplayLabel.textAlignment = .center
        diplayLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(diplayLabel)
        
        edgeConstraints.append(diplayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding))
        edgeConstraints.append(diplayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding))
        edgeConstraints.append(self.bottomAnchor.constraint(equalTo: diplayLabel.bottomAnchor, constant: padding))
        edgeConstraints.append(self.trailingAnchor.constraint(equalTo: diplayLabel.trailingAnchor, constant: padding))
        
        edgeConstraints.forEach { $0.isActive = true }
    
    }
}
