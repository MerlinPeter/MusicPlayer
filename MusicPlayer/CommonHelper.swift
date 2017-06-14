//
//  CommonController.swift
//  MusicPlayer
//
//  Created by MA on 5/23/17.
//  Copyright © 2017 M A. All rights reserved.
//

class CommonHelper {
  
    
    static func seconds2Timestamp(intSeconds:Int)->String {
        
        let mins:Int = intSeconds/60
      //  let hours:Int = mins/60
        let secs:Int = intSeconds%60
        
       // let strTimestamp:String = ((hours<10) ? "0" : "") + String(hours) + ":" +
        let strTimestamp:String = ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return strTimestamp
    }
}
