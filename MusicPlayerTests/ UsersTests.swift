//
//  MusicPlayerTests.swift
//  MusicPlayerTests
//
//  Created by MA on 5/6/17.
//  Copyright © 2017 M A. All rights reserved.
//

import XCTest
@testable import MusicPlayer

class UsersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_user_struct_set(){
        
        let User_1 = User(uid :"u001" , email :"merl@merl.com")
        XCTAssertEqual(User_1.uid, "u001", "user id setup")
        XCTAssertEqual(User_1.email, "merl@merl.com", "user id setup")
        
        
    
    }
    
    
}
