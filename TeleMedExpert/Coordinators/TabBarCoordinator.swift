//
//  TabBarCoordinator.swift
//  TeleMedExpert
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
        let dashboardNavigationController = UINavigationController()
        let appointmentsNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()
        
        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNavigationController)
        let appointmentsCoordinator = AppointmentsCoordinator(navigationController: appointmentsNavigationController)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        
        childCoordinators.append(dashboardCoordinator)
        childCoordinators.append(appointmentsCoordinator)
        childCoordinators.append(profileCoordinator)
        
        tabBarController.viewControllers = [
            dashboardNavigationController,
            appointmentsNavigationController,
            profileNavigationController
        ]
        
        dashboardCoordinator.start()
        appointmentsCoordinator.start()
        profileCoordinator.start()
    }
}
