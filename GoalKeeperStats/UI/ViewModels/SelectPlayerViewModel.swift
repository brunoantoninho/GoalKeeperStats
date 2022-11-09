//
//  SelectPlayerViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 08/11/2022.
//

import RealmSwift

class SelectPlayerViewModel {
    
    private var notificationToken: NotificationToken!
    var playersList: Results<Player>?
    weak var delegate: TableNotificationProtocol?
    
    init() {
        playersList = RealmManager.shared().objects(type: Player.self)
        notificationToken = playersList?.observe({ [weak self] change in
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
        notificationToken.invalidate()
    }
}
