//
//  Alerting.swift
//  TraktTest
//
//  Created by Peter Su on 22/11/2016.
//  Copyright © 2016 fenroar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction] = []) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.count > 0 {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            // if no actions are set, add a default action so that user can dismiss the alert
            let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

