//
//  LoginViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit

final class LoginViewController: UIViewController, Storyboarded {
    static var storyboard: Storyboard = .auth
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

private extension LoginViewController {
    func configureUI() {
        configureContainerView()
        configureMainTitleLabel()
        configureSubtitleLabel()
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureForgotPasswordButton()
        configureSignUpButton()
    }
    
    func configureContainerView() {
        
    }
    
    func configureMainTitleLabel() {
        
    }
    
    func configureSubtitleLabel() {
        
    }
    
    func configureEmailLabel() {
        
    }
    
    func configureEmailTextField() {
        
    }
    
    func configurePasswordLabel() {
        
    }
    
    func configurePasswordTextField() {
        
    }
    
    func configureForgotPasswordButton() {
        
    }
    
    func configureLoginButton() {
        
    }
    
    func configureSignUpButton() {
        
    }
}
