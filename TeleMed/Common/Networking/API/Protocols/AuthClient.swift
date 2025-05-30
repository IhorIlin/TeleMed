//
//  AuthClient.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

protocol AuthClient {
    func login(with request: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkClientError>
}
