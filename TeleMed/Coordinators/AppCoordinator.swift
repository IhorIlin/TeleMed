//
//  AppCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let tabBarController = UITabBarController()
    private let navigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    var isLogedIn: Bool = false // Will be replaced with AuthClient
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if isLogedIn {
            
        } else {
            showAuthFlow()
        }
    }
    
    func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators.append(authCoordinator)
        
        authCoordinator.onAuthSuccess = { [weak self] in
            self?.showTabBar()
        }
        
        authCoordinator.start()
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func showTabBar() {
        print("Navigate to tabBar :-) !")
    }
}
