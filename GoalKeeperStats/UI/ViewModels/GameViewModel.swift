//
//  GameViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import RealmSwift

protocol GameViewModelDelegate: AnyObject {
    func populateUI(game: Game)
}

class GameViewModel {
    
    var game: Game!
    var notificationToken: NotificationToken!
    weak var delegate: GameViewModelDelegate?
    
    deinit {
        notificationToken.invalidate()
    }
    
    init(gameId: Int) {
        game = RealmManager.shared().object(ofType: Game.self, forPrimaryKey: gameId)
        delegate?.populateUI(game: game)
        notificationToken = game.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .change( _, _):
                self.delegate?.populateUI(game: self.game)
            case .deleted:
                self.delegate?.populateUI(game: self.game)
            case .error(let error):
                log.error(error)
            }
        }
    }
    
    func saveDefendedScore(defendedScore: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.game.defendedScore = defendedScore
        }
    }
    
    func saveVisitingTeamScore(visitingTeamScore: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.game.visitingTeamScore = visitingTeamScore
        }
    }
    
    func saveHomeTeamScore(homeTeamScore: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.game.homeTeamScore = homeTeamScore
        }
    }
}
