//
//  GamePlayerStats.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 11/11/2022.
//

import RealmSwift

class GamePlayerStats: Object {
    @Persisted(primaryKey: true) var playerId = 0
    @Persisted var defendedScore = 0
    @Persisted var missedScore = 0
    @Persisted var gameId = 0
}
