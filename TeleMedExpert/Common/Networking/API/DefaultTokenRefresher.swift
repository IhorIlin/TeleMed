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
    private let keychainService: KeychainService
    
    private var refreshSubject = PassthroughSubject<Void, NetworkClientError>()
    private var isRefreshing = false
    private var lock = NSLock()
    
    init(networkClient: NetworkClient, keychainService: KeychainService) {
        self.networkClient = networkClient
        self.keychainService = keychainService
    }
    
    func refreshTokenIfNeeded() -> AnyPublisher<Void, NetworkClientError> {
        lock.lock()
        
        defer { lock.unlock() }
        
        if isRefreshing {
            return refreshSubject.eraseToAnyPublisher()
        }
        
        isRefreshing = true
        
        do {
            let refreshToken = try keychainService.loadString(for: .refreshToken)
            let endpoint = AuthEndpoint.refreshToken(refreshToken: refreshToken)
            
            return networkClient.request(endpoint: endpoint)
                .tryMap { [weak self] (response: RefreshTokenResponseDTO) in
                    try self?.keychainService.saveAuthTokens(authToken: response.token, refreshToken: response.refreshToken)
                }
                .mapError { error in
                    if let mappedError = error as? NetworkClientError {
                        return mappedError
                    } else {
                        return .unknown
                    }
                }
                .handleEvents(receiveCompletion: { [weak self] completion in
                    self?.lock.lock()
                    self?.isRefreshing = false
                    self?.lock.unlock()
                    
                    switch completion {
                    case .failure(let error):
                        self?.refreshSubject.send(completion: .failure(error))
                    case .finished:
                        self?.refreshSubject.send()
                        self?.refreshSubject.send(completion: .finished)
                    }
                    
                    self?.refreshSubject = PassthroughSubject<Void, NetworkClientError>()
                })
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkClientError.unauthorized).eraseToAnyPublisher()
        }
    }
}
