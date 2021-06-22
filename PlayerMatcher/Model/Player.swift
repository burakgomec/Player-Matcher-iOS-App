//
//  Player.swift
//  PlayerMatcher
//
//  Created by Burak on 22.06.2021.
//

import Foundation


struct Player : Codable{
    let id, username : String
    let status : Bool
    let level, kdRatio:Int
}
