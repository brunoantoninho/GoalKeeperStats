//
//  Player.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import RealmSwift

class Player: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
    @Persisted var age = 0
    @Persisted var section = ""
    @Persisted var photo: Data?
    @Persisted var gamePlayed = List<String>()
    
//    init(name: String, age: Int = 0, section: String = "", photo: Data? = nil, gamePlayed: List<String> = List<String>()) {
//        super.init()
//        
//        self.id = Int(Date().timeIntervalSince1970 * 1000)
//        self.name = name
//        self.age = age
//        self.section = section
//        self.photo = photo
//        self.gamePlayed = gamePlayed
//    }
}
