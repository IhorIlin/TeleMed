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
        let keychainService = KeychainService()
        let networkClient = DefaultNetworkClient()
        
        let tokenRefresher = DefaultTokenRefresher(networkClient: networkClient,
                                                   keychainService: keychainService)
        
        let protectedNetworkClient = DefaultProtectedNetworkClient(networkClient: networkClient,
                                                                   tokenRefresher: tokenRefresher,
                                                                   keychainService: keychainService)
        
        let viewModel = DashboardViewModel(userClient: DefaultUserClient(protectedNetworkClient: protectedNetworkClient))
        
        let dashboardController = DashboardViewController(viewModel: viewModel)
        
        dashboardController.startCallCallback = { [weak self] userId in
            self?.delegate?.startLocalCall(userId: userId)
        }
            
        navigationController.pushViewController(dashboardController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
    }
}
