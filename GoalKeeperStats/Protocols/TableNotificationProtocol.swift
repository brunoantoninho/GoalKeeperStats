//
//  TableNotificationProtocol.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 08/11/2022.
//

import Foundation

protocol TableNotificationProtocol: AnyObject {
    
    func initial()
    
    func deletions(rows: [Int])
    
    func insertions(rows: [Int])
    
    func modifications(rows: [Int])
}
