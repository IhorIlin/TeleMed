//
//  SignUpViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit
import Combine

final class SignUpViewController: UIViewController, Storyboarded {
    static var storyboard: Storyboard = .auth
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var formCenterYConstraint: NSLayoutConstraint!
    
    private var viewModel = SignUpViewModel(authClient: DefaultAuthClient(networkClient: DefaultNetworkClient()), keychain: KeychainService.shared)
    private var cancellables = Set<AnyCancellable>()
    
    var showLogin: (() -> Void)?
    var showHome: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        observeKeyboardNotifications()
        
        bindFields()
        
        validateForm()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        viewModel.register()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        showLogin?()
    }
    
    @IBAction func roleChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.userRole = .patient
        case 1:
            viewModel.userRole = .doctor
        default:
            break
        }
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    deinit {
        print("deinit for SignUpViewController")
    }
}

// MARK: - Binding -
extension SignUpViewController {
    private func bindFields() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .compactMap { notification in
                guard let field = notification.object as? UITextField else {
                    return ""
                }
                
                return field.text
            }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { notification in
                guard let field = notification.object as? UITextField else {
                    return ""
                }
                
                return field.text
            }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: confirmPasswordTextField)
            .compactMap { notification in
                guard let field = notification.object as? UITextField else {
                    return ""
                }
                
                return field.text
            }
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .navigateToHome:
                    self?.showHome?()
                case .showError(let error):
                    // display error on UI
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func validateForm() {
        viewModel.$isFormValid
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellables)
    }
}

extension SignUpViewController {
    private func configureUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = ColorPalette.Background.primary
        
        segmentedControl.selectedSegmentIndex = viewModel.userRole == .patient ? 0 : 1
        
        configureContainerView()
        configureMainTitleLabel()
        configureSubtitleLabel()
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureConfirmPasswordLabel()
        configureConfirmPasswordTextField()
        configureSignUpButton()
        configureLoginButton()
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
        passwordTextField.returnKeyType = .next
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configureConfirmPasswordLabel() {
        confirmPasswordLabel.font = Font.TextStyle.caption()
        confirmPasswordLabel.textColor = ColorPalette.Text.primary
        confirmPasswordLabel.text = "Confirm Password"
    }
    
    func configureConfirmPasswordTextField() {
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.layer.cornerRadius = 12
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = ColorPalette.Border.borderPrimary.cgColor
    }
    
    func configureLoginButton() {
        loginButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        loginButton.titleLabel?.font = Font.TextStyle.caption()
    }
    
    func configureSignUpButton() {
        signUpButton.layer.cornerRadius = 12
        signUpButton.backgroundColor = ColorPalette.Button.vibrantGreen
        signUpButton.tintColor = ColorPalette.Button.primaryText
    }
}

// Keyboard avoiding stuff
private extension SignUpViewController {
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
        return [emailTextField, passwordTextField, confirmPasswordTextField].first(where: { $0.isFirstResponder })
    }
}

// MARK: - UITextFieldDelegate -
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
