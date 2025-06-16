//
//  MockAuthClient.swift
//  TeleMedExpertTests
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Combine
@testable import TeleMedExpert

final class MockAuthClient: AuthClient {
    var loginCalled = false
    var loginResult: Result<LoginResponseDTO, NetworkClientError> = .success(.init(token: "mock-token"))

    func login(with request: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkClientError> {
        loginCalled = true

        switch loginResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: NetworkClientError.self)
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
