//
//  AuthClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

protocol AuthClient {
    func login(with request: LoginRequestDTO) -> AnyPublisher<AuthResponse, NetworkClientError>
    func register(with request: RegisterRequestDTO) -> AnyPublisher<AuthResponse, NetworkClientError>
}
