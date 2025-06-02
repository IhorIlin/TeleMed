//
//  AuthCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var onAuthSuccess: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLogin()
    }
    
    private func showLogin() {
        let loginController = LoginViewController.instantiate()
        
        loginController.showSignUp = { [weak self] in
            self?.showSignUp()
        }
        
        loginController.showForgotPassword = { [weak self] in
            self?.showLogin()
        }
        
        navigationController.pushViewController(loginController, animated: false)
    }
    
    private func showSignUp() {
        let signUpController = SignUpViewController.instantiate()
        
        signUpController.showLogin = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        signUpController.showHome = { [weak self] in
            self?.onAuthSuccess?()
        }
        
        navigationController.pushViewController(signUpController, animated: true)
    }
}
