//
//  AppCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    let tabBarController = UITabBarController()
    var childCoordinators: [Coordinator] = []
    
    func start() {
        let authCoordinator = AuthCoordinator()
        childCoordinators.append(authCoordinator)
        
        authCoordinator.start()
    }
}
