//
//  Error.swift
//  MusicPlayer
//
//  Created by MA on 5/30/17.
//  Copyright © 2017 M A. All rights reserved.
//

 

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}
