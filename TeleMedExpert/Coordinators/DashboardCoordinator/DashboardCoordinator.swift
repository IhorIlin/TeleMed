//
//  DashboardCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

final class DashboardCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var dependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: DashboardCoordinatorDelegate?
    
    private var userClient: UserClient {
        dependencies.userClient
    }
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = DashboardViewModel(userClient: userClient)
        
        let dashboardController = DashboardViewController(viewModel: viewModel)
        
        dashboardController.startCallCallback = { [weak self] userId in
            self?.delegate?.startCall(userId: userId)
        }
        
        dashboardController.logout = { [weak self] in
            self?.delegate?.logout()
        }
            
        navigationController.pushViewController(dashboardController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
    }
}
