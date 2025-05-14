//
//  AuthCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    
    func start() {
        navigationController.pushViewController(LoginViewController.instantiate(), animated: false)
    }
}
