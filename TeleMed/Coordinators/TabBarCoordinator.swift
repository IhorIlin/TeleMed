//
//  TabBarCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 02.06.2025.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        
    }
}
