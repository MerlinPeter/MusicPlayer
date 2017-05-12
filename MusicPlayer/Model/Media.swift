//
//  Songs.swift
//  MusicPlayer
//
//  Created by MA on 5/9/17.
//  Copyright © 2017 M A. All rights reserved.
//

import UIKit

class Media: NSObject {
    
    
    var title: String
    var location: String
    var filename:String
    
    
    
    init(title: String, location: String, filename:String) {
        self.title = title
        self.location = location
        self.filename = filename
    }


}
