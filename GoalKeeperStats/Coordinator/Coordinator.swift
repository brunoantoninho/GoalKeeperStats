//
//  Coordinator.swift
//  GoolKeeperTracker
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
