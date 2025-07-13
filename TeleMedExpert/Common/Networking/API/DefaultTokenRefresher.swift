//
//  DefaultTokenRefresher.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 15.06.2025.
//

import Foundation
import Combine

final class DefaultTokenRefresher: TokenRefresher {
    private let networkClient: NetworkClient
    private let keychainService: KeychainStore

    private var currentRefreshPublisher: AnyPublisher<Void, NetworkClientError>?
    private var lock = NSLock()

    init(networkClient: NetworkClient, keychainService: KeychainStore) {
        self.networkClient = networkClient
        self.keychainService = keychainService
    }

    func refreshTokenIfNeeded() -> AnyPublisher<Void, NetworkClientError> {
        lock.lock()

        if let existingPublisher = currentRefreshPublisher {
            print("Refresh skipped: already refreshing.")
            lock.unlock()
            return existingPublisher
        }

        print("Refresh started.")
        let publisher = createRefreshPublisher()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.lock.lock()
                self?.currentRefreshPublisher = nil
                self?.lock.unlock()
            })
            .share()
            .eraseToAnyPublisher()

        currentRefreshPublisher = publisher

        lock.unlock()

        return publisher
    }

    private func createRefreshPublisher() -> AnyPublisher<Void, NetworkClientError> {
        do {
            let refreshToken = try keychainService.loadString(for: .refreshToken)
            let endpoint = AuthEndpoint.refreshToken(refreshToken: refreshToken)
            
            return networkClient.request(endpoint: endpoint)
                .tryMap { [weak self] (response: AuthResponse) in
                    try self?.keychainService.saveAuthTokens(
                        authToken: response.token.token,
                        refreshToken: response.token.refreshToken
                    )
                    print("Refresh token successfully saved.")
                }
                .mapError { error in
                    if let mappedError = error as? NetworkClientError {
                        return mappedError
                    } else {
                        return .unknown
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            print("No refresh token found in Keychain.")
            return Fail(error: .unauthorized).eraseToAnyPublisher()
        }
    }
}
