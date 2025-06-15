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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileController = ProfileViewController()
        
        navigationController.pushViewController(profileController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
    }
}
