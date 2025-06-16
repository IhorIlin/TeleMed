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
    
    var isLogedIn: Bool = false // Will be replaced with AuthClient
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if isLogedIn {
            showMainTabBar()
        } else {
            showAuthFlow()
        }
    }
    
    func showAuthFlow() {
        let navigationController = UINavigationController()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        childCoordinators.append(authCoordinator)
        
        authCoordinator.onAuthSuccess = { [weak self] in
            
            self?.childCoordinators.removeAll()
            
            self?.showMainTabBar()
        }
        
        authCoordinator.start()
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func showMainTabBar() {
        let tabBarController = MainTabBarViewController()
        
        let mainTabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController)
        
        childCoordinators.append(mainTabBarCoordinator)
        
        mainTabBarCoordinator.start()
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
    }
}
