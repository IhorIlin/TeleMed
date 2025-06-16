//
//  AuthCoordinator.swift
//  TeleMedExpert
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
        let loginViewModel = LoginViewModel(authClient: DefaultAuthClient(networkClient: DefaultNetworkClient()),
                                            keychain: KeychainService())
        
        let loginController = LoginViewController(viewModel: loginViewModel)
        
        loginController.showSignUp = { [weak self] in
            self?.showSignUp()
        }
        
        loginController.showForgotPassword = { [weak self] in
            self?.showLogin()
        }
        
        loginController.showHome = { [weak self] in
            self?.onAuthSuccess?()
        }
        
        navigationController.pushViewController(loginController, animated: false)
    }
    
    private func showSignUp() {
        let signUpViewModel = SignUpViewModel(authClient: DefaultAuthClient(networkClient: DefaultNetworkClient()),
                                              keychain: KeychainService())
        
        let signUpController = SignUpViewController(viewModel: signUpViewModel)
        
        signUpController.showLogin = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        signUpController.showHome = { [weak self] in
            self?.onAuthSuccess?()
        }
        
        navigationController.pushViewController(signUpController, animated: true)
    }
}
