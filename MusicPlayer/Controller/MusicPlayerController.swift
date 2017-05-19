//
//  MusicPlayerController.swift
//  MusicPlayer
//
//  Created by MA on 5/11/17.
//  Copyright © 2017 M A. All rights reserved.
//

import UIKit

class MusicPlayerController: UIViewController {
    
    @IBOutlet weak var music_label: UILabel!
    var audio_record:Media!
    
    override func viewDidLoad() {
        
        music_label.text = audio_record.title
    }

}
