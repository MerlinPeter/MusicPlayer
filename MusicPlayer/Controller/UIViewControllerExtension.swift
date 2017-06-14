//
//  UIViewControllerExtension.swift
//  MusicPlayer
//
//  Created by MA on 5/25/17.
//  Copyright © 2017 M A. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
     }
    
}
