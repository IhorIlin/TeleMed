//
//  LoginViewModel.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var isFormValid: Bool = false
    
    private var authService: AuthClient
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: AuthClient) {
        self.authService = authService
        
        setupValidation()
    }
    
    func login() {
        authService.login(with: LoginRequestDTO(email: email, password: password))
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let networkClientError):
                    print("failure: \(networkClientError.localizedDescription)")
                }
            } receiveValue: { response in
                do {
                    try KeychainService.shared.save(response.token, for: .authToken)
                } catch {
                    // handle error !
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
