//
//  TabBarCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 02.06.2025.
//

import UIKit
import Combine

final class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    let pushService: any PushManaging
    weak var delegate: TabBarCoordinatorDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(tabBarController: UITabBarController, pushService: any PushManaging) {
        self.tabBarController = tabBarController
        self.pushService = pushService
    }
    
    func start() {
        let dashboardNavigationController = UINavigationController()
        let appointmentsNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()
        
        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNavigationController)
        let appointmentsCoordinator = AppointmentsCoordinator(navigationController: appointmentsNavigationController)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.delegate = self
        
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
        
        // test stuff
        pushService.requestNotificationPermission()
            .sink { completion in
                print("Failure")
            } receiveValue: { _ in
                print("Success")
            }.store(in: &cancellables)

    }
}

// MARK: - ProfileCoordinatorDelegate -
extension TabBarCoordinator: ProfileCoordinatorDelegate {
    func logout() {
        delegate?.logout()
    }
}
