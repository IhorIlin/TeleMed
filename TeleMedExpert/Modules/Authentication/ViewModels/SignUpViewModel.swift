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
    
    private let authClient: AuthClient
    private let keychain: KeychainStore
    private let sessionService: SessionMonitor
    
    init(authClient: AuthClient, keychain: KeychainStore, sessionService: SessionMonitor) {
        self.authClient = authClient
        self.keychain = keychain
        self.sessionService = sessionService
        
        setupValidation()
    }
    
    func register() {
        authClient.register(with: RegisterRequestDTO(email: email, password: password, role: userRole))
            .sink { completion in
                print("Finished register!")
            } receiveValue: { [weak self] response in
                self?.handleResponse(response)
            }.store(in: &cancellables)
    }
    
    private func setupValidation() {
        Publishers.CombineLatest3($email, $password, $confirmPassword)
            .map { email, password, confirmPassword in
                return email.isValidEmail && password.isValidPassword && password == confirmPassword
            }
            .assign(to: &$isFormValid)
    }
    
    private func handleResponse(_ response: AuthResponse) {
        do {
            try keychain.saveAuthTokens(authToken: response.token.token, refreshToken: response.token.refreshToken)
            print("authToken: \(response.token.token) \nrefreshToken: \(response.token.refreshToken)")
            
            sessionService.currentUser.id = response.userId
            sessionService.currentUser.email = response.email
            sessionService.currentUser.role = response.role
            
            self.subject.send(.navigateToHome)
        } catch {
            self.subject.send(.showError(error.localizedDescription))
            
            print(error.localizedDescription)
        }
    }
}
