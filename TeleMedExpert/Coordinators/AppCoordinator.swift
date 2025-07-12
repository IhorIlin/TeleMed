//
//  AppCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let dependencies: AppDependencies
    
    private var pushService: PushManaging {
        dependencies.pushService
    }
    
    private var socketManager: SocketManaging {
        dependencies.socketManager
    }
    
    private var sessionService: SessionMonitor {
        dependencies.sessionService
    }
    
    private var callManager: CallManaging {
        dependencies.callManager
    }
    
    init(window: UIWindow, dependencies: AppDependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        if sessionService.isLoggedIn {
            showMainTabBar()
        } else {
            showAuthFlow()
        }
    }
    
    func showAuthFlow() {
        let navigationController = UINavigationController()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController, dependencies: dependencies)
        
        authCoordinator.delegate = self
        
        childCoordinators.append(authCoordinator)
        
        authCoordinator.start()
        
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func showMainTabBar() {
        let viewModel = MainTabBarViewModel(pushService: pushService, socketManager: socketManager, callManager: callManager)
        
        let tabBarController = MainTabBarViewController(viewModel: viewModel)
        
        let mainTabBarCoordinator = TabBarCoordinator(tabBarController: tabBarController, dependencies: dependencies)
        
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
        sessionService.logout()
        
        childCoordinators.removeAll()
        
        showAuthFlow()
    }
}
