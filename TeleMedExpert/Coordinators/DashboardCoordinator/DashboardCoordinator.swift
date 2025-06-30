//
//  DashboardCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

final class DashboardCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: DashboardCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dashboardController = DashboardViewController()
        
        dashboardController.startCallCallback = { [weak self] in
            self?.delegate?.startLocalCall()
        }
        
        navigationController.pushViewController(dashboardController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
    }
}
