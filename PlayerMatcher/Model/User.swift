//
//  User.swift
//  PlayerMatcher
//
//  Created by Burak on 22.06.2021.
//

import Foundation

class User{
    var username: String
    var email: String
    var password: String
    
    private static var singleUser: User?
    
    static func setUser(username: String, email: String, password: String){
        if(singleUser == nil){
            singleUser = User(username: username, email: email, password: password)
        }
    }
    
    static func getUser()->User?{
        if(singleUser != nil){
            return singleUser
        }
        else{
            return nil
        }
    }
    
    private init(username: String, email: String, password: String){
        self.username = username
        self.email = email
        self.password = password
    }
}




