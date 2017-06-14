//
//  DataHelperProtocol.swift
//  MusicPlayer
//
//  Created by MA on 5/30/17.
//  Copyright © 2017 M A. All rights reserved.
//


protocol DataHelperProtocol {
    associatedtype T

  
    static func insert_row (record : T, completion:  @escaping (Error?)-> ())

}
