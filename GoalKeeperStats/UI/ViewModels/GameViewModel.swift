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
    
    var game: Game?
    var currentPlayerStats: GamePlayerStats?
    var notificationToken: NotificationToken?
    weak var delegate: GameViewModelDelegate?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    init() {
        delegate?.populateUI()
        notificationToken = game?.observe { [weak self] change in
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
    
    func saveDefendedScore(score: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.currentPlayerStats?.defendedScore = score
        }
    }
    
    func saveMissedScore(score: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.currentPlayerStats?.missedScore = score
        }
    }
    
    func saveVisitingTeamScore(score: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.game?.visitingTeamScore = score
        }
    }
    
    func saveHomeTeamScore(score: Int) {
        RealmManager.shared().safeWrite { [weak self] in
            self?.game?.homeTeamScore = score
        }
    }
}
