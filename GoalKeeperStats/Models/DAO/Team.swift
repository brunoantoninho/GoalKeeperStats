//
//  Team.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 11/11/2022.
//

import Foundation

import RealmSwift

class Team: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
    @Persisted var address = ""
    @Persisted var photo: Data?
    @Persisted var gamesList = List<Game>()
    
    var games: [Game] { Array(gamesList) }
}
