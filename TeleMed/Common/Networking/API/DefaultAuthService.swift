//
//  DefaultAuthService.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

final class DefaultAuthService: AuthService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func login(with request: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkClientError> {
        let endpoint = AuthEndpoint.login(email: request.email, password: request.password)
        
        return networkClient.request(endpoint: endpoint)
    }
}
