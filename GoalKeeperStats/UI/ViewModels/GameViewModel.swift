//
//  GameViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import RealmSwift

protocol GameViewModelDelegate: AnyObject {
    func populateUI()
}

class GameViewModel {
    
    var game: Game
    var notificationToken: NotificationToken!
    weak var delegate: GameViewModelDelegate?
    
    deinit {
        notificationToken.invalidate()
    }
    
    init(game: Game) {
        self.game = game
        delegate?.populateUI()
        notificationToken = game.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .change( _, _):
                self.delegate?.populateUI()
            case .deleted:
                self.delegate?.populateUI()
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
