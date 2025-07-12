//
//  DefaultProtectedNetworkClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 15.06.2025.
//

import Foundation
import Combine

final class DefaultProtectedNetworkClient: ProtectedNetworkClient {
    private let networkClient: NetworkClient
    private let tokenRefresher: TokenRefresher
    private let keychainService: KeychainStore
    
    init(networkClient: NetworkClient, tokenRefresher: TokenRefresher, keychainService: KeychainStore) {
        self.networkClient = networkClient
        self.tokenRefresher = tokenRefresher
        self.keychainService = keychainService
    }
    
    func request<T: Decodable>(endpoint: any Endpoint) -> AnyPublisher<T, NetworkClientError> {
        var protectedEndpoint: Endpoint
       
        do {
            protectedEndpoint = try injectToken(in: endpoint)
        } catch {
            return Fail(error: NetworkClientError.unauthorized).eraseToAnyPublisher()
        }
        
        return networkClient.request(endpoint: protectedEndpoint)
            .catch { [weak self] error -> AnyPublisher<T, NetworkClientError> in
                guard let self, case .unauthorized = error else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                
                return retryRequest(endpoint: endpoint, error: error)
            }
            .eraseToAnyPublisher()
    }
    
    private func retryRequest<T: Decodable>(endpoint: any Endpoint, error: NetworkClientError) -> AnyPublisher<T, NetworkClientError> {
        return self.tokenRefresher.refreshTokenIfNeeded()
            .flatMap { [weak self] _ -> AnyPublisher<T, NetworkClientError> in
                guard let self else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                do {
                    let updatedEndpoint = try self.injectToken(in: endpoint)
                    return self.networkClient.request(endpoint: updatedEndpoint)
                } catch {
                    return Fail(error: .unauthorized).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func injectToken(in endpoint: Endpoint) throws -> Endpoint {
        let token = try keychainService.loadString(for: .authToken)
        
        var updated = endpoint
        
        updated.headers["Authorization"] = "Bearer \(token)"
        
        return updated
    }
}
