//
//  LoginViewModel.swift
//  TeleMed
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
    
    @Published var email: String = "e@e.com"
    @Published var password: String = "Password1!"
    @Published private(set) var isFormValid: Bool = false
    
    private var authClient: AuthClient
    private var keychain: KeychainStore
    private var cancellables: Set<AnyCancellable> = []
    
    var subject = PassthroughSubject<Event, Never>()
    
    init(authClient: AuthClient, keychain: KeychainStore) {
        self.authClient = authClient
        self.keychain = keychain
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
                do {
                    try self?.keychain.saveAuthTokens(authToken: response.token, refreshToken: response.refreshToken)
                    print("authToken: \(response.token) \nrefreshToken: \(response.refreshToken)")
                    self?.subject.send(.navigateToHome)
                } catch {
                    // handle error !
                    self?.subject.send(.showError(error.localizedDescription))
                    print(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                email.isValidEmail && password.isValidPassword
            }
            .assign(to: &$isFormValid)
    }
}
