//
//  Songs.swift
//  MusicPlayer
//
//  Created by MA on 5/9/17.
//  Copyright © 2017 M A. All rights reserved.
//
import FirebaseDatabase
 
class Media {
    
    let key: String
    var title: String
    var location: String
    var filename:String
    let ref: DatabaseReference?
    
    
    
    init(title: String, location: String, filename:String , key: String = " " ) {
        self.key = key
        self.title = title
        self.location = location
        self.filename = filename
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["name"] as! String
        location = snapshotValue["location"] as! String
        filename = snapshotValue["file"] as! String
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "file": filename,
            "location": location,
            "name": title
        ]
    }

}
