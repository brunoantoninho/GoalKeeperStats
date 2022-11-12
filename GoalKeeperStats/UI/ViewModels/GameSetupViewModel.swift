//
//  GameTypeViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 31/10/2022.
//

import Foundation
import RealmSwift

protocol GameSetupDelegate: AnyObject {
    func navigateToGame(game: Game)
    func setHomeTeam(team: Team?)
    func setVisitingTeam(team: Team?)
}

class GameSetupViewModel {
    
    private var notificationToken: NotificationToken!
    var gamesList: Results<Game>?
    var playersList = [Player]()
    weak var gameSetupDelegate: GameSetupDelegate?
    var homeTeam: Team? {
        didSet {
            gameSetupDelegate?.setHomeTeam(team: homeTeam)
        }
    }
    var visitorTeam: Team? {
        didSet {
            gameSetupDelegate?.setVisitingTeam(team: visitorTeam)
        }
    }
    
    init() {
        observeGameListBD()
    }
    
    private func observeGameListBD() {
        gamesList = RealmManager.shared().objects(type: Game.self)
        notificationToken = gamesList?.observe({ [weak self] change in
            switch change {
                
            case .initial(_):
                break
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                
                if !insertions.isEmpty {
                    if let game = self?.gamesList?[insertions.first!] {
                        self?.gameSetupDelegate?.navigateToGame(game: game)
                    }
                }
                
            case .error(let error):
                log.error(error)
            }
        })
    }
    
    deinit {
        notificationToken.invalidate()
    }
    
    func saveGame(id: Int, homeTeam: Team, visitingTeam: Team, date: Date, players: [Player]) {
        let game = Game()
        game.id = id
        game.homeTeam = homeTeam        
        game.visitingTeam = visitingTeam
        game.date = date
        
        for player in players {
            let playerStats = GamePlayerStats()
            playerStats.playerId = player.id
            playerStats.gameId = id
            game.playerStatsList.append(playerStats)
        }
        
        RealmManager.shared().save(game)
    }
}
