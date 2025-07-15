//
//  TabBarCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 02.06.2025.
//

import UIKit
import Combine

final class TabBarCoordinator: Coordinator {
    let tabBarController: MainTabBarViewController
    let dependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    weak var delegate: TabBarCoordinatorDelegate?
    
    private var socketManager: SocketManaging {
        dependencies.socketManager
    }
    
    private var callClient: CallClient {
        dependencies.callClient
    }
    
    private var sessionService: SessionMonitor {
        dependencies.sessionService
    }
    
    private var callManager: CallManaging {
        dependencies.callManager
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(tabBarController: MainTabBarViewController, dependencies: AppDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let dashboardNavigationController = UINavigationController()
        let appointmentsNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()
        
        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNavigationController, dependencies: dependencies)
        let appointmentsCoordinator = AppointmentsCoordinator(navigationController: appointmentsNavigationController, dependencies: dependencies)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController, dependencies: dependencies)
        
        dashboardCoordinator.delegate = self
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
    }
}

// MARK: - ProfileCoordinatorDelegate -
extension TabBarCoordinator: ProfileCoordinatorDelegate {
    func logout() {
        delegate?.logout()
    }
}

// MARK: - DashboardCoordinatorDelegate -
extension TabBarCoordinator: DashboardCoordinatorDelegate {
    func startLocalCall(userId: UUID) {
        let viewModel = CallViewModel(callDTO: StartCallRequestDTO(calleeId: userId, callType: .video),
                                      webRTCManager: WebRTCManager(),
                                      socketManager: socketManager,
                                      callClient: callClient,
                                      sessionService: sessionService)
        
        let callController = CallViewController(viewModel: viewModel)
        
        callController.modalPresentationStyle = .fullScreen
        
        self.tabBarController.present(callController, animated: true)
    }
}
