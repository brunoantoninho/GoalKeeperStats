//
//  GameTypeViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 31/10/2022.
//

import RealmSwift

protocol GameSetupDelegate: AnyObject {
    func navigateToGame(gameId: Int)
}

class GameSetupViewModel {
    
    private var notificationToken: NotificationToken!
    var gamesList: Results<Game>?
    weak var delegate: GameSetupDelegate?
    
    init() {
        gamesList = RealmManager.shared().objects(type: Game.self)
        notificationToken = gamesList?.observe({ [weak self] change in
            switch change {
                
            case .initial(_):
                break
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                
                if !insertions.isEmpty {
                    if let gameId = self?.gamesList?[insertions.first!].id {
                        self?.delegate?.navigateToGame(gameId: gameId)
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
}
