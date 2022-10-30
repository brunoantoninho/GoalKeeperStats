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
    @Persisted var level = ""
    @Persisted var photo: Data?
    @Persisted var gamePlayed = List<String>()
}
