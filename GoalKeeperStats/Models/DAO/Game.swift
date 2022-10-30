//
//  Game.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import RealmSwift

class Game: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var homeTeamName = ""
    @Persisted var homeTeamScore = 0
    @Persisted var visitingTeamName = ""
    @Persisted var visitingTeamScore = 0
    @Persisted var defendedScore = 0
}
