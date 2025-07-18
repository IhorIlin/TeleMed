//
//  LoginViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 14.05.2025.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    enum Event {
        case navigateToHome
        case showError(String)
    }
    
    @Published var email: String = ""
    @Published var password: String = "Password1!"
    @Published private(set) var isFormValid: Bool = false
    
    private let authClient: AuthClient
    private let keychain: KeychainStore
    private let sessionService: SessionService
    
    private var cancellables: Set<AnyCancellable> = []
    
    private(set) var subject = PassthroughSubject<Event, Never>()
    
    init(authClient: AuthClient, keychain: KeychainStore, sessionService: SessionService) {
        self.authClient = authClient
        self.keychain = keychain
        self.sessionService = sessionService
        
        setupValidation()
    }
    
    func login() {
        authClient.login(with: LoginRequestDTO(email: email, password: password))
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let networkClientError):
                    print("failure: \(networkClientError.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                self?.handleResponse(response)
            }.store(in: &cancellables)
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.isValidEmail && password.isValidPassword
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
