//
//  RecordController.swift
//  MusicPlayer
//
//  Created by MA on 5/17/17.
//  Copyright © 2017 M A. All rights reserved.
//
import UIKit
import AVFoundation
import FirebaseStorage

class RecordController: UIViewController,AVAudioRecorderDelegate ,AVAudioPlayerDelegate{
    
    @IBOutlet weak var progress_bar: UIProgressView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progress_label: UILabel!
    
    @IBOutlet weak var prayer_name: UITextField!
    @IBOutlet weak var play_button: UIBarButtonItem!
    @IBOutlet weak var pause_button: UIBarButtonItem!
    
    @IBOutlet weak var progress_recorded_audio: UISlider!
    //let ref = FIRDatabase.database().reference()

    let storage = Storage.storage()

     var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var progress_timer: Timer!
    var player_progress_timer: Timer!
    
    let recording_file = "temp_audio.m4a"

    @IBOutlet weak var r_progress_label: UILabel!

    override func viewDidLoad() {
         super.viewDidLoad()
 
        recordingSession = AVAudioSession.sharedInstance()
      
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }

    }
    
    func loadRecordingUI() {
        recordButton.setTitle("Tap to Record", for: .highlighted)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
     }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(recording_file)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            //ToDo --  fix the continue logic
            
      
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
          
            
            recordButton.setTitle("Tap to Stop", for: .normal)
            
            progress_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update_progress), userInfo: nil, repeats: true)
            

        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        progress_timer.invalidate()
        
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Done", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    func pauseRecording(success: Bool) {
        
        if let _ = audioRecorder {
            if (audioRecorder.isRecording == false){
                audioRecorder.record()
                
                recordButton.setTitle("Tap to Stop", for: .normal)
                
      
            }else{
                audioRecorder.pause()
                recordButton.setTitle("Tap to Continue", for: .normal)
                
            }

        }
       /* if success {
            recordButton.setTitle("Tap to Continue", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }*/
    }
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            pauseRecording(success: true)
        }
    }
    
    func update_progress()  {
        if (audioRecorder.isRecording){
            let seconds = (audioRecorder.currentTime)
            progress_label.text = CommonHelper.seconds2Timestamp(intSeconds: Int(seconds))
            progress_bar.setProgress( Float(audioRecorder.currentTime/180) ,animated: true)
        }
    }
    func player_progress()  {
        
        if (audioPlayer!.isPlaying){
        progress_recorded_audio.setValue(Float((audioPlayer?.currentTime)!), animated: false)
        
        r_progress_label.text = CommonHelper.seconds2Timestamp(intSeconds: Int(((audioPlayer?.duration)! - (audioPlayer?.currentTime)!)))
        }
    }


    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @IBAction func finish_audio(_ sender: Any) {
        
        finishRecording(success: true)
        recordButton.setTitle("Tap to Record", for: .highlighted)
        progress_label.text = CommonHelper.seconds2Timestamp(intSeconds: Int(0))
        progress_bar.setProgress( Float(0.0) ,animated: true)

        let audioFilename = getDocumentsDirectory().appendingPathComponent(recording_file)
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
            try audioPlayer = AVAudioPlayer(contentsOf:
                audioFilename)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1.0
            
            audioPlayer!.play()
            
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }

    }
 
    @IBAction func playAudio(_ sender: AnyObject) {
   
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

            do {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                } catch let error as NSError {
                    print("audioSession error: \(error.localizedDescription)")
                }
                try audioPlayer = AVAudioPlayer(contentsOf:
                    audioFilename)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.volume = 1.0

                audioPlayer!.play()
                
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }

    @IBAction func tool_play_pressed(_ sender: Any) {
        //let audioFilename = getDocumentsDirectory().appendingPathComponent(recording_file)
        if let local_player = audioPlayer {//it is already initialized
            
            if local_player.isPlaying == false {
                
                local_player.play()
                
                play_button.isEnabled = false
                
                pause_button.isEnabled = true
                
            }
            
            
        }else{
            let audioFilename = URL.init(fileURLWithPath: Bundle.main.path(
                forResource: "music3",
                ofType: "mp3")!)
            do {
    
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                } catch let error as NSError {
                    print("audioSession error: \(error.localizedDescription)")
                }
                try audioPlayer = AVAudioPlayer(contentsOf:
                    audioFilename)
                
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.volume = 1.0
                audioPlayer!.play()
                self.progress_recorded_audio.maximumValue = Float(audioPlayer!.duration)
                self.progress_recorded_audio.value = 0.0
                player_progress_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.player_progress), userInfo: nil, repeats: true)
                
                
                play_button.isEnabled = false
                
                pause_button.isEnabled = true

            } catch let error as NSError {
                
                print("audioPlayer error: \(error.localizedDescription)")
          
            }
            

        }
        
    }
    
 
    @IBAction func tool_pauseb_pressed(_ sender: Any) {
        
        if let local_player = audioPlayer {
            
            if local_player.isPlaying {
              
                local_player.pause()
                
                pause_button.isEnabled = false
                
                play_button.isEnabled = true
              
            }
            
        }
    }
 
  
    @IBAction func discard_recordingb(_ sender: Any) {
        
    }
    @IBAction func save_recordingb(_ sender: Any) {
        let audio_file = URL.init(fileURLWithPath: Bundle.main.path(
            forResource: "music3",
            ofType: "mp3")!)
        
       let storagePath = "gs://sound-demo-b3241.appspot.com/music3.mp3"
        let spaceRef = storage.reference(forURL: storagePath)
        
 
        if let t_prayer_name = prayer_name.text ,!t_prayer_name.isEmpty {
        let  m:Media = Media(title: t_prayer_name, location: "dssdds", filename: "music3.mp3")
            
            _   = MediaDataHelper.insert_row(record: m, completion: { error  in
                
                if (error != nil){
                    print(error?.localizedDescription ?? "")
                }
            })
            
            
        }else{
            
            alert(message: "Please enter prayer name")
        }
       /* spaceRef.putFile(audio_file, metadata: nil) { (metadata, error) in
             
            if error != nil {
             print(error?.localizedDescription)
            }
            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                print(downloadUrl)
                let values: [String : Any] = ["audioUrl": downloadUrl]
                print( values)
                
                
            }
            
                 // self.sendMessageWith(properties: values)
         }*/
    }
    
 
 }
