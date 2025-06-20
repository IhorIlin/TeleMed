//
//  ProfileCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: ProfileCoordinatorDelegate?
    
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
        
        let viewModel = ProfileViewModel(userClient: DefaultUserClient(protectedNetworkClient: protectedNetworkClient))
        
        let profileController = ProfileViewController(viewModel: viewModel)
        
        profileController.logoutAction = { [weak self] in
            self?.delegate?.logout()
        }
        
        navigationController.pushViewController(profileController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
    }
}
