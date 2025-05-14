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
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

private extension LoginViewController {
    func configureUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = ColorPalette.Background.primary
        
        configureContainerView()
        configureMainTitleLabel()
        configureSubtitleLabel()
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureForgotPasswordButton()
        configureLoginButton()
        configureSignUpButton()
    }
    
    func configureContainerView() {
        containerView.backgroundColor = ColorPalette.Background.secondary
        
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = ColorPalette.Shadow.primaryShadow.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 8
    }
    
    func configureMainTitleLabel() {
        mainTitleLabel.font = Font.TextStyle.titleLarge()
        mainTitleLabel.textColor = ColorPalette.Text.primary
    }
    
    func configureSubtitleLabel() {
        subtitleLabel.font = Font.TextStyle.titleMedium()
        subtitleLabel.textColor = ColorPalette.Text.secondary
    }
    
    func configureEmailLabel() {
        emailLabel.font = Font.TextStyle.caption()
        emailLabel.textColor = ColorPalette.Text.primary
        emailLabel.text = "Email"
    }
    
    func configureEmailTextField() {
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configurePasswordLabel() {
        passwordLabel.font = Font.TextStyle.caption()
        passwordLabel.textColor = ColorPalette.Text.primary
        passwordLabel.text = "Password"
    }
    
    func configurePasswordTextField() {
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configureForgotPasswordButton() {
        forgotPasswordButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        forgotPasswordButton.titleLabel?.font = Font.TextStyle.caption()
    }
    
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 12
        loginButton.backgroundColor = ColorPalette.Button.primaryBackground
        loginButton.tintColor = ColorPalette.Button.primaryText
    }
    
    func configureSignUpButton() {
        signUpButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        signUpButton.titleLabel?.font = Font.TextStyle.caption()
    }
}
