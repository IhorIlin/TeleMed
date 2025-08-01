//
//  AuthCoordinator.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: AuthCoordinatorDelegate?
    
    private var keychainService: KeychainStore {
        dependencies.keychainService
    }
    
    private var authClient: AuthClient {
        dependencies.authClient
    }
    
    private var sessionService: SessionService {
        dependencies.sessionService
    }
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showLogin()
    }
    
    private func showLogin() {
        let loginViewModel = LoginViewModel(authClient: authClient,
                                            keychain: keychainService,
                                            sessionService: sessionService)
        
        let loginController = LoginViewController(viewModel: loginViewModel)
        
        loginController.showSignUp = { [weak self] in
            self?.showSignUp()
        }
        
        loginController.showForgotPassword = { [weak self] in
            self?.showLogin()
        }
        
        loginController.showHome = { [weak self] in
            self?.delegate?.userAuthenicatedSuccessfully()
        }
        
        navigationController.pushViewController(loginController, animated: false)
    }
    
    private func showSignUp() {
        let signUpViewModel = SignUpViewModel(authClient: authClient,
                                              keychain: keychainService,
                                              sessionService: sessionService)
        
        let signUpController = SignUpViewController(viewModel: signUpViewModel)
        
        signUpController.showLogin = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        signUpController.showHome = { [weak self] in
            self?.delegate?.userAuthenicatedSuccessfully()
        }
        
        navigationController.pushViewController(signUpController, animated: true)
    }
}
