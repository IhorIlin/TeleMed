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
    
    private var authService: AuthService
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: AuthService) {
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
                // Store token in Keychain!
                print(response.token)
            }.store(in: &cancellables)
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                !email.isEmpty && !password.isEmpty 
            }.assign(to: &$isFormValid)
    }
}
