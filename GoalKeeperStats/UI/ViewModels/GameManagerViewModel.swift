//
//  GameManagerViewModel.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import RealmSwift

protocol GameManagerViewModelDelegate: AnyObject {
    
    func initial()
    
    func deletions(rows: [Int])
    
    func insertions(rows: [Int])
    
    func modifications(rows: [Int])
}

class GameManagerViewModel {
    
    var gamesList: Results<Game>?
    private var notificationToken: NotificationToken?
    weak var delegate: GameManagerViewModelDelegate?
    
    init() {
        gamesList = RealmManager.shared().objects(type: Game.self)
        notificationToken = gamesList?.observe({ [weak self] change in
            switch change {
                
            case .initial(_):
                self?.delegate?.initial()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                if !deletions.isEmpty {
                    self?.delegate?.deletions(rows: deletions)
                }
                
                if !insertions.isEmpty {
                    self?.delegate?.insertions(rows: insertions)
                }
                
                if !modifications.isEmpty {
                    self?.delegate?.modifications(rows: modifications)
                }
            case .error(let error):
                log.error(error)
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
