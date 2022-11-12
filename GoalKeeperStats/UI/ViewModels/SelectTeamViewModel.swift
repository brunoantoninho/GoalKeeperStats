//
//  SelectGameViewModel.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 11/11/2022.
//

import RealmSwift

class SelectTeamViewModel {
    
    private var notificationToken: NotificationToken!
    var teamList: Results<Team>?
    weak var delegate: TableNotificationProtocol?
    
    init() {
        teamList = RealmManager.shared().objects(type: Team.self)
        notificationToken = teamList?.observe({ [weak self] change in
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
