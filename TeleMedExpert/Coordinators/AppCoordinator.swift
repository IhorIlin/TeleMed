//
//  AppCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    var sessionMonitor: SessionMonitor
    
    init(window: UIWindow) {
        self.window = window
        sessionMonitor = SessionService(keychainService: KeychainService())
    }
    
    func start() {
        if sessionMonitor.isLogedIn {
            showMainTabBar()
        } else {
            showAuthFlow()
        }
    }
    
    func showAuthFlow() {
        let navigationController = UINavigationController()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        authCoordinator.delegate = self
        
        childCoordinators.append(authCoordinator)
        
        authCoordinator.start()
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func showMainTabBar() {
        let tabBarController = MainTabBarViewController()
        
        let mainTabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController)
        
        mainTabBarCoordinator.delegate = self
        
        childCoordinators.append(mainTabBarCoordinator)
        
        mainTabBarCoordinator.start()
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func userAuthenicatedSuccessfully() {
        childCoordinators.removeAll()
        
        showMainTabBar()
    }
}

extension AppCoordinator: TabBarCoordinatorDelegate {
    func logout() {
        sessionMonitor.logout()
        
        childCoordinators.removeAll()
        
        showAuthFlow()
    }
}
