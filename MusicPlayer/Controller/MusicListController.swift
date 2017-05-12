//
//  MusicListController.swift
//  MusicPlayer
//
//  Created by MA on 5/7/17.
//  Copyright © 2017 M A. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import AVFoundation
//TODO: animation while song is playing
//

class MusicListController: UITableViewController ,AVAudioPlayerDelegate{
    var ref: FIRDatabaseReference!
    let storage = FIRStorage.storage()
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var navigation_bar: UINavigationItem!
 

    var music_list: [Media] = []

    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        super.viewDidLoad()
  
       let pause_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action:  #selector(self.pauseButton(sender:)))
        navigation_bar.rightBarButtonItem = pause_button
 
        
        let userID = FIRAuth.auth()?.currentUser?.uid
         ref.child(userID!).observe( .value, with: { (snapshot) in
            // Get user value
            var fireitems: [Media] = []
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let dvalue = rest.value as? NSDictionary
                let medianame:String! = dvalue!.value(forKey: "name") as? String
                let medialocation:String! = dvalue!.value(forKey: "location") as? String // TODO: - Need to review
                let mediafilename:String! = dvalue!.value(forKey: "file") as? String
                 fireitems.append(Media(title: medianame, location: medialocation, filename: mediafilename))
                
            }
                        self.music_list = fireitems
                        self.tableView.reloadData()
            self.tableView.separatorColor = UIColor.white;
 self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine

         }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    
    // Mark: Firebase player
    
    

    func streamsong(file:String){
        
      
        
        let storagePath = "gs://sound-demo-b3241.appspot.com/"+file
        let spaceRef = storage.reference(forURL: storagePath)
  
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print("download err")
            } else {
                do {
                    
                    self.audioPlayer = try AVAudioPlayer(data: data!)
                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
 
                } catch {
                    print(" play err")
                }
            }
        }
       

    }
    
    
  
    //playToPause()x`
    @IBAction func playButton(sender: UIBarButtonItem) {
        if (pause_play()){
            
        

        let pause_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action:  #selector(self.pauseButton(sender:)))
        navigation_bar.rightBarButtonItem = pause_button
            }
    
    }
    
    // pauseToPlay()
    @IBAction func pauseButton(sender: UIBarButtonItem){
        if (pause_play()){

        let play_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(self.playButton(sender:)))
        navigation_bar.rightBarButtonItem = play_button
        }
        
    }
    
    
    func pause_play() -> Bool{
        
        guard let _ = audioPlayer else {
            print ("Audio Player Not available")
            return false
            
            
        }

       
          if audioPlayer.isPlaying {
            
            audioPlayer.pause()
            
            
        } else {
            
            audioPlayer.play()
            
            
            
            
        }
        
        return true

    }
   
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music_list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        cell.cell_label.textColor = UIColor.white
     
        let selectedmedia =  music_list[indexPath.row]
        cell.cell_label.text = selectedmedia.title
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

           let selectedmedia =  music_list[indexPath.row]
        
          streamsong(file:selectedmedia.filename)

            /*let groceryItem = items[indexPath.row]
        let toggledCompletion = !groceryItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])*/
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        audioPlayer.stop()
    }
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        do {
            try
                FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }


}
