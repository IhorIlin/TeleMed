//
//  SignUpViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit
import Combine

final class SignUpViewController: UIViewController {
    private var containerView = UIView()
    private var mainTitleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var emailLabel = UILabel()
    private var emailTextField = AuthTextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = AuthTextField()
    private var confirmPasswordLabel = UILabel()
    private var confirmPasswordTextField = AuthTextField()
    private var segmentedControl = UISegmentedControl()
    private var signUpButton = UIButton()
    private var loginButton = UIButton()
    
    private var formCenterYConstraint: NSLayoutConstraint!
    
    private var viewModel: SignUpViewModel
    private var cancellables = Set<AnyCancellable>()
    
    var showLogin: (() -> Void)?
    var showHome: (() -> Void)?
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impemented!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        observeKeyboardNotifications()
        
        bindFields()
        
        validateForm()
    }
    
    @objc
    private func signUpButtonPressed(_ sender: UIButton) {
        viewModel.register()
    }
    
    @objc
    private func loginButtonPressed(_ sender: UIButton) {
        showLogin?()
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    deinit {
        print("SignUpViewController deinited!")
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
                case .showError:
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
        configureEmailTextField()
        configureEmailLabel()
        configurePasswordTextField()
        configurePasswordLabel()
        configureConfirmPasswordTextField()
        configureConfirmPasswordLabel()
        configureSegmentedControl()
        configureSignUpButton()
        configureLoginButton()
    }
    
    func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        formCenterYConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        view.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            formCenterYConstraint,
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -16)
        ])
        
        containerView.backgroundColor = ColorPalette.Background.secondary
        
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = ColorPalette.Shadow.primaryShadow?.cgColor
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
        
        mainTitleLabel.text = "Create Account 👤"
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
        
        subtitleLabel.text = "Join us and start your journey"
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
        emailTextField.layer.borderColor = ColorPalette.Border.borderPrimary?.cgColor
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
        
        passwordTextField.placeholder = "Create password"
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .next
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = ColorPalette.Border.borderPrimary?.cgColor
    }
    
    func configureConfirmPasswordLabel() {
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(confirmPasswordLabel)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: confirmPasswordLabel, attribute: .leading, relatedBy: .equal, toItem: confirmPasswordTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: confirmPasswordLabel, attribute: .bottom, relatedBy: .equal, toItem: confirmPasswordTextField, attribute: .top, multiplier: 1, constant: -4)
        ])
        
        confirmPasswordLabel.font = Font.TextStyle.caption()
        confirmPasswordLabel.textColor = ColorPalette.Text.primary
        confirmPasswordLabel.text = "Confirm Password"
    }
    
    func configureConfirmPasswordTextField() {
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(confirmPasswordTextField)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: confirmPasswordTextField, attribute: .leading, relatedBy: .equal, toItem: passwordTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: confirmPasswordTextField, attribute: .trailing, relatedBy: .equal, toItem: passwordTextField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: confirmPasswordTextField, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: confirmPasswordTextField, attribute: .height, relatedBy: .equal, toItem: passwordTextField, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        confirmPasswordTextField.placeholder = "Repeat password"
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.layer.cornerRadius = 12
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = ColorPalette.Border.borderPrimary?.cgColor
    }
    
    func configureSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(segmentedControl)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: segmentedControl, attribute: .top, relatedBy: .equal, toItem: confirmPasswordTextField, attribute: .bottom, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: segmentedControl, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 35)
        ])
        
        segmentedControl.insertSegment(withTitle: "patient", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "doctor", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.publisher(for: \.selectedSegmentIndex)
            .sink { [weak self] index in
                self?.viewModel.userRole = index == 0 ? .patient : .doctor
            }
            .store(in: &cancellables)
    }
    
    func configureLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(loginButton)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -16)
        ])
        
        loginButton.setTitleColor(ColorPalette.Link.primary, for: .normal)
        loginButton.titleLabel?.font = Font.TextStyle.caption()
        loginButton.setTitle("Already have an account? Log in here", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
    }
    
    func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(signUpButton)
        
        containerView.addConstraints([
            NSLayoutConstraint(item: signUpButton, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 1, constant: 60),
            NSLayoutConstraint(item: signUpButton, attribute: .leading, relatedBy: .equal, toItem: confirmPasswordTextField, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: signUpButton, attribute: .trailing, relatedBy: .equal, toItem: confirmPasswordTextField, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: signUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: signUpButton, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -65)
        ])
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
        signUpButton.setTitle("✅ Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.lightGray, for: .disabled)
        signUpButton.layer.cornerRadius = 12
        signUpButton.backgroundColor = ColorPalette.Button.vibrantGreen
        signUpButton.tintColor = ColorPalette.Button.primaryText
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
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
