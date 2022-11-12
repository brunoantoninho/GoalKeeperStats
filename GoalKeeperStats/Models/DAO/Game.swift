//
//  Game.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import RealmSwift

class Game: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var homeTeam: Team!
    @Persisted var homeTeamScore = 0
    @Persisted var visitingTeam: Team!
    @Persisted var visitingTeamScore = 0
    @Persisted var date: Date!
    @Persisted var playerStatsList = List<GamePlayerStats>()
    
    var playerStats: [GamePlayerStats] { Array(playerStatsList) }
}
