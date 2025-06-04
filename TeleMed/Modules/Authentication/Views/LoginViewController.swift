//
//  LoginViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    private var containerView = UIView()
    private var mainTitleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var emailLabel = UILabel()
    private var emailTextField = AuthTextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = AuthTextField()
    private var forgotPasswordButton = UIButton()
    private var loginButton = UIButton()
    private var signUpButton = UIButton()
    
    private var formCenterYConstraint: NSLayoutConstraint!
    
    private let viewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    var showSignUp: (() -> Void)?
    var showForgotPassword: (() -> Void)?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindFields()
        bindFormValidation()
        observeKeyboardNotifications()
    }
    
    @objc
    private func forgotPasswordPressed(_ sender: UIButton) {
        showForgotPassword?()
    }
    
    @objc
    private func loginPressed(_ sender: UIButton) {
        viewModel.login()
    }
    
    @objc
    private func signUpPressed(_ sender: UIButton) {
        showSignUp?()
    }
    
    @objc
    func endEditing() {
        view.endEditing(true)
    }
    
    deinit {
        print("deinit for LoginViewController")
    }
}

private extension LoginViewController {
    func bindFields() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .compactMap { notification in
                guard let field = notification.object as? UITextField else {
                    return ""
                }
                
                return field.text ?? ""
            }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { notification in
                guard let field = notification.object as? UITextField else {
                    return ""
                }
                
                return field.text ?? ""
            }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
    }
    
    func bindFormValidation() {
        viewModel.$isFormValid
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
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
        configureEmailTextField()
        configureEmailLabel()
        configurePasswordTextField()
        configurePasswordLabel()
        configureForgotPasswordButton()
        configureLoginButton()
        configureSignUpButton()
    }
    
    func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        formCenterYConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        view.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            formCenterYConstraint
        ])
        
        containerView.backgroundColor = ColorPalette.Background.secondary
        
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = ColorPalette.Shadow.primaryShadow.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 8
    }
    
    func configureMainTitleLabel() {
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainTitleLabel)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: mainTitleLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: mainTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        mainTitleLabel.text = "Welcome Back 👋"
        mainTitleLabel.font = Font.TextStyle.titleLarge()
        mainTitleLabel.textColor = ColorPalette.Text.primary
    }
    
    func configureSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(subtitleLabel)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: mainTitleLabel, attribute: .bottom, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: subtitleLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        subtitleLabel.text = "Please login to your account"
        subtitleLabel.font = Font.TextStyle.titleMedium()
        subtitleLabel.textColor = ColorPalette.Text.secondary
    }
    
    func configureEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(emailLabel)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: emailLabel, attribute: .leading, relatedBy: .equal, toItem: emailTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emailLabel, attribute: .bottom, relatedBy: .equal, toItem: emailTextField, attribute: .top, multiplier: 1, constant: -4)
        ])
        
        emailLabel.font = Font.TextStyle.caption()
        emailLabel.textColor = ColorPalette.Text.primary
        emailLabel.text = "Email"
    }
    
    func configureEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(emailTextField)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: emailTextField, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: emailTextField, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: emailTextField, attribute: .top, relatedBy: .equal, toItem: subtitleLabel, attribute: .bottom, multiplier: 1, constant: 75),
            NSLayoutConstraint(item: emailTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        ])
        
        emailTextField.placeholder = "your@email.com"
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configurePasswordLabel() {
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(passwordLabel)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: passwordLabel, attribute: .leading, relatedBy: .equal, toItem: passwordTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: passwordLabel, attribute: .bottom, relatedBy: .equal, toItem: passwordTextField, attribute: .top, multiplier: 1, constant: -4)
        ])
        
        passwordLabel.font = Font.TextStyle.caption()
        passwordLabel.textColor = ColorPalette.Text.primary
        passwordLabel.text = "Password"
    }
    
    func configurePasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(passwordTextField)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: passwordTextField, attribute: .leading, relatedBy: .equal, toItem: emailTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: passwordTextField, attribute: .trailing, relatedBy: .equal, toItem: emailTextField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: emailTextField, attribute: .bottom, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: emailTextField, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configureForgotPasswordButton() {
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(forgotPasswordButton)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: forgotPasswordButton, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: forgotPasswordButton, attribute: .trailing, relatedBy: .equal, toItem: passwordTextField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: forgotPasswordButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
        
        forgotPasswordButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        forgotPasswordButton.titleLabel?.font = Font.TextStyle.caption()
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordPressed(_:)), for: .touchUpInside)
    }
    
    func configureLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(loginButton)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 60),
            NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: passwordTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: passwordTextField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -65)
        ])
        
        loginButton.layer.cornerRadius = 12
        loginButton.backgroundColor = ColorPalette.Button.indigo
        loginButton.tintColor = ColorPalette.Button.primaryText
        loginButton.setTitleColor(UIColor.lightGray, for: .disabled)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        loginButton.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
    }
    
    func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(signUpButton)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: signUpButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: signUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: signUpButton, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -16)
        ])
        
        signUpButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        signUpButton.titleLabel?.font = Font.TextStyle.caption()
        signUpButton.setTitle("Don't have an account? Sign up here", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

// Keyboard avoiding stuff
private extension LoginViewController {
    func observeKeyboardNotifications() {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
        
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGRect.zero }
        
        Publishers.Merge(willShow, willHide)
            .receive(on: RunLoop.main)
            .sink { [weak self] keyboardFrame in
                self?.adjustViewForKeyboard(keyboardFrame: keyboardFrame)
            }
            .store(in: &cancellables)
    }
    
    private func adjustViewForKeyboard(keyboardFrame: CGRect) {
        if let activeField = getActiveTextField() {
            let fieldFrame = activeField.convert(activeField.bounds, to: view)
            let keyboardTop = keyboardFrame.minY
            let fieldBottom = fieldFrame.maxY
            
            let overlap = fieldBottom - keyboardTop
            
            let offset = max(overlap + 16, 0) // Add padding
            
            UIView.animate(withDuration: 0.3) {
                self.formCenterYConstraint.constant = -offset
                self.view.layoutIfNeeded()
            }
        } else {
            if keyboardFrame == .zero {
                UIView.animate(withDuration: 0.3) {
                    self.formCenterYConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
                return
            }
        }
    }
    
    private func getActiveTextField() -> UITextField? {
        return [emailTextField, passwordTextField].first(where: { $0.isFirstResponder })
    }
}
