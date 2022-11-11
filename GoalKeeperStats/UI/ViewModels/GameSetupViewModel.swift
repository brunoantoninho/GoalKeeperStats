//
//  GameTypeViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 31/10/2022.
//

import RealmSwift

protocol GameSetupDelegate: AnyObject {
    func navigateToGame(game: Game)
}

class GameSetupViewModel {
    
    private var notificationToken: NotificationToken!
    var gamesList: Results<Game>?
    var playersList = [Player]()
    weak var delegate: GameSetupDelegate?
    
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
                        self?.delegate?.navigateToGame(game: game)
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
    
    func saveGame(id: Int, homeTeam: String, visitingTeam: String, players: [Player]) {
        let game = Game()
        game.id = id
        game.homeTeamName = homeTeam
        game.visitingTeamName = visitingTeam
        game.players.append(objectsIn: players)
        RealmManager.shared().save(game)
    }
}
