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
    //    private var games: [Game] { Array(gamesList ?? Results) }
    
    init() {
        gamesList = RealmManager.shared().objects(type: Game.self)
        notificationToken = gamesList?.observe({ [weak self] change in
            switch change {
                
            case .initial(_):
                print("initial")
                self?.delegate?.initial()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                if !deletions.isEmpty {
                    print("deletions")
                    self?.delegate?.deletions(rows: deletions)
                }
                
                if !insertions.isEmpty {
                    print("insertions")
                    self?.delegate?.insertions(rows: insertions)
                }
                
                if !modifications.isEmpty {
                    print("modifications")
                    self?.delegate?.modifications(rows: modifications)
                }
            case .error(_):
                print("initial")
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
