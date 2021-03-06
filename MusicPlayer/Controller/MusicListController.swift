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
 

class MusicListController:  UITableViewController ,AVAudioPlayerDelegate{
     let storage = Storage.storage()
    var audioPlayer : AVAudioPlayer!
    var updater : CADisplayLink! = nil
    var play_button :UIBarButtonItem!
    var pause_button :UIBarButtonItem!
    
    
    @IBOutlet weak var song_time_pending: UILabel!
   // @IBOutlet weak var progress_view: UIProgressView!

    @IBOutlet weak var progress_view: UISlider!
    @IBOutlet weak var navigation_bar: UINavigationItem!
 

    var music_list: [Media] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.clearsSelectionOnViewWillAppear = false
        animate_cell()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 

        play_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(self.playButton(sender:)))
        play_button.tintColor = UIColor.white

        pause_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action:  #selector(self.pauseButton(sender:)))
        pause_button.tintColor = UIColor.white
        navigation_bar.rightBarButtonItem = pause_button
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 0.03, green: 0.22, blue: 0.39, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

 
        
  
            
 
        _   = MediaDataHelper.query_all(  completion: { (media_array : [Media]) in
            
            
            if media_array.count  > 0 {
                
                self.music_list = media_array
                self.tableView.reloadData()
                
            }
            
            
        })
            

        
        

        
    }
    
    @IBAction func progress_view_changed(_ sender: Any) {
        
            audioPlayer.currentTime = TimeInterval(progress_view.value)
        
    }
    
    
    func animate_cell(){
        
        guard let _ = self.tableView.indexPathForSelectedRow else {
            return
        }
        if let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow! ) as? ItemCell{
            cell.music_player_image.alpha = 1
            UIView.animate(withDuration: 1, delay: 0, options:[ UIViewAnimationOptions.curveEaseOut,.repeat], animations: {
                
                cell.music_player_image.alpha = 0.0
                
                
            }, completion: nil)
            
        }
    }
    
  
    //playToPause()x`
    @IBAction func playButton(sender: UIBarButtonItem) {
        
        if (pause_play()){
            
            animate_cell()
            navigation_bar.rightBarButtonItem = pause_button
            
        }
    
    }
    
    // pauseToPlay()
    @IBAction func pauseButton(sender: UIBarButtonItem){
        
        if (pause_play()){
            
            if let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow! ) as? ItemCell{
                
                cell.music_player_image.layer.removeAllAnimations()
                
            }
            navigation_bar.rightBarButtonItem = play_button
        }
        
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
        let cell = tableView.cellForRow(at: indexPath) as! ItemCell
        cell.cell_label.backgroundColor = UIColor.darkGray
        animate_cell()
       // performSegue(withIdentifier: "song_player", sender: selectedmedia)
    
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        audioPlayer.stop()
        let cell = tableView.cellForRow(at: indexPath) as! ItemCell
        cell.music_player_image.alpha = 0
        cell.cell_label.textColor = UIColor.white
        audioPlayer.stop()
        cell.music_player_image.layer.removeAllAnimations()
        self.view.layer.removeAllAnimations()
        navigation_bar.rightBarButtonItem = pause_button

     }
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        
        do {
            try
                Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let mediaItem: Media = music_list[indexPath.row]
               _   = MediaDataHelper.delete_row(record: mediaItem, completion: { (error) in
                
                
                if error  !=  nil {
                    
                    print("Row Deleted")
                    
                }else{
                    
                    print(error?.localizedDescription)
                }
                
                
            })

        }
    }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let music_player_vc = segue.destination as! MusicPlayerController
        
        music_player_vc.audio_record = sender as? Media
        
        
    }
    
    //MARK: -- Custome Functions
    
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
    
    
    func update_progress(){
 
           progress_view.setValue(Float(audioPlayer.currentTime), animated: false)

           song_time_pending.text = CommonHelper.seconds2Timestamp(intSeconds: Int((audioPlayer.duration - audioPlayer.currentTime)))
      
    }

    
    func streamsong(file:String){
        
        let storagePath = "gs://sound-demo-b3241.appspot.com/"+file
        let spaceRef = storage.reference(forURL: storagePath)

        spaceRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print("download err")
            } else {
                do {
                    
                    self.audioPlayer = try AVAudioPlayer(data: data!)
                    self.audioPlayer.delegate = self

                    self.audioPlayer.prepareToPlay()
                    self.audioPlayer.play()
                    
                    self.progress_view.maximumValue = Float(self.audioPlayer.duration)
                    self.progress_view.value = 0.0
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update_progress), userInfo: nil, repeats: true)
 
                 } catch {
                    print(" play err")
                }
            }
        }
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow! ) as? ItemCell{
            
            cell.music_player_image.layer.removeAllAnimations()
             
        }

    }



}
