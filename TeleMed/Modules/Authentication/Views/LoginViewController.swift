//
//  LoginViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit
import Combine

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
    
    @IBOutlet weak var formCenterYConstraint: NSLayoutConstraint!
    
    private let viewModel = LoginViewModel(authClient: DefaultAuthClient(networkClient: DefaultNetworkClient()))
    
    private var cancellables = Set<AnyCancellable>()
    
    var showSignUp: (() -> Void)?
    var showForgotPassword: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindFields()
        bindFormValidation()
        observeKeyboardNotifications()
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        showForgotPassword?()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        viewModel.login()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        showSignUp?()
    }
    
    @objc func endEditing() {
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
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
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
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
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
        loginButton.backgroundColor = ColorPalette.Button.indigo
        loginButton.tintColor = ColorPalette.Button.primaryText
    }
    
    func configureSignUpButton() {
        signUpButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        signUpButton.titleLabel?.font = Font.TextStyle.caption()
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
