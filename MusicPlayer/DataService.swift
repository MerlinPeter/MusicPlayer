//
//  DataService.swift
//  
//
//  Created by MA on 5/30/17.
//
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    static let data_service = DataService();
    
    private var _FIREBASE_BASE_REF =  Database.database().reference()
      
    var FIREBASE_BASE_REF : DatabaseReference {
        return _FIREBASE_BASE_REF
    }
    
    
    
    
}
