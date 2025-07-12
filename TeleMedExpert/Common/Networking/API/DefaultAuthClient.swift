//
//  DefaultAuthClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

final class DefaultAuthClient: AuthClient {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func login(with request: LoginRequestDTO) -> AnyPublisher<AuthResponse, NetworkClientError> {
        let endpoint = AuthEndpoint.login(email: request.email, password: request.password)
        
        return networkClient.request(endpoint: endpoint)
    }
    
    func register(with request: RegisterRequestDTO) -> AnyPublisher<AuthResponse, NetworkClientError> {
        let endpoint = AuthEndpoint.signUp(email: request.email, password: request.password, role: request.role.rawValue)
        
        return networkClient.request(endpoint: endpoint)
    }
}
