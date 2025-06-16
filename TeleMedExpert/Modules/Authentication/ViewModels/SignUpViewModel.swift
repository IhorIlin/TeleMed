//
//  SignUpViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 14.05.2025.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    enum Event {
        case navigateToHome
        case showError(String)
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userRole: UserRole = .patient
    @Published var isFormValid: Bool = false
    
    var subject = PassthroughSubject<Event, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var authClient: AuthClient
    private var keychain: KeychainStore
    
    init(authClient: AuthClient, keychain: KeychainStore) {
        self.authClient = authClient
        self.keychain = keychain
        
        setupValidation()
    }
    
    func register() {
        authClient.register(with: RegisterRequestDTO(email: email, password: password, role: userRole))
            .sink { completion in
                print("Finished register!")
            } receiveValue: { [weak self] response in
                do {
                    try self?.keychain.saveAuthTokens(authToken: response.token, refreshToken: response.refreshToken)
                    self?.subject.send(.navigateToHome)
                } catch {
                    self?.subject.send(.showError(error.localizedDescription))
                    print("Error: \(error.localizedDescription)")
                }
            }.store(in: &cancellables)
    }
    
    private func setupValidation() {
        Publishers.CombineLatest3($email, $password, $confirmPassword)
            .map { email, password, confirmPassword in
                return email.isValidEmail && password.isValidPassword && password == confirmPassword
            }
            .assign(to: &$isFormValid)
    }
}
