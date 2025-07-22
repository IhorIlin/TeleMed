//
//  ProfileCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    private var userClient: UserClient {
        dependencies.userClient
    }
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = ProfileViewModel(userClient: userClient)
        
        let profileController = ProfileViewController(viewModel: viewModel)
        
        profileController.logoutAction = { [weak self] in
            self?.delegate?.logout()
        }
        
        navigationController.pushViewController(profileController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
    }
}
