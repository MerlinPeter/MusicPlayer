//
//  MediaDataHelper.swift
//  MusicPlayer
//
//  Created by MA on 5/30/17.
//  Copyright © 2017 M A. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase


class MediaDataHelper: DataHelperProtocol {
    
   static var  return_code : Int64!
     // TODO: - share prayers
  
    // MARK: - Session User Function

    static func getUserID()->String {
        
        if let user_id:String = Auth.auth().currentUser?.uid {
            
            return user_id
            
        }else{
            
            print("User ID retrirval failed ")
            return "0000"
            
        }
     
    }

    // MARK: - Firebase DB Functions
    
    // MARK: Save record
    static func insert_row(record: Media, completion: @escaping (Error?) -> ()) {
        
        let key = DataService.data_service.FIREBASE_BASE_REF.child(getUserID()).child("music_list").childByAutoId()
        key.setValue(record.toAnyObject(), withCompletionBlock: { (error, snapshot) in
            
            completion(error)
        })
        
        
    }
    
    // MARK: Delete record
    static func delete_row(record: Media, completion: @escaping (Error?) -> ()) {
        let title = "delete"
         record.ref?.removeValue( completionBlock: { (error, snapshot) in
            if (error == nil){
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                    AnalyticsParameterItemID: "id-\(title)" as NSObject,
                    AnalyticsParameterItemName: title as NSObject,
                    AnalyticsParameterContentType: "cont" as NSObject
                    ])
            }
            completion(error)
        })
        
    }
 
    // MARK: Select all records
    static func query_all( completion: @escaping ([Media]) -> ())  {
        
        
        let userID = Auth.auth().currentUser?.uid
        DataService.data_service.FIREBASE_BASE_REF.child(userID!).child("music_list").observe( .value, with: { (snapshot)  in
            // Get user value
            var fireitems: [Media] = []
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                
               let mediaItem =  Media(snapshot: rest)
               fireitems.append(mediaItem)
                print(mediaItem.filename)
                
            }
            completion(fireitems)
            
        }) { (error) in
            print(error.localizedDescription)
         }
        
    }


}

/*
 for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
 let dvalue = rest.value as? NSDictionary
 let medianame:String! = dvalue!.value(forKey: "name") as? String
 let medialocation:String! = dvalue!.value(forKey: "location") as? String // TODO: - Need to review
 let mediafilename:String! = dvalue!.value(forKey: "file") as? String
 fireitems.append(Media(title: medianame, location: medialocation, filename: mediafilename))
 
 }
 */
