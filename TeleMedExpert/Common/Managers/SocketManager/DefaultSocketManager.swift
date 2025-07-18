//
//  SocketManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation
import Combine

final class DefaultSocketManager: SocketManager {
    private let configuration: SocketConfiguration
    private let tokenRefresher: TokenRefresher
    private let keychainService: KeychainStore
    private var webSocketTask: URLSessionWebSocketTask?
    
    private let messageSubject = PassthroughSubject<SocketMessage<AnyCodable>, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var messagePublisher: AnyPublisher<SocketMessage<AnyCodable>, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var isConnected: Bool {
        webSocketTask?.state == .running
    }
    
    init(configuration: SocketConfiguration, tokenRefresher: TokenRefresher, keychainService: KeychainStore) {
        self.configuration = configuration
        self.tokenRefresher = tokenRefresher
        self.keychainService = keychainService
    }
    
    func connect() async throws {
        try await refreshTokenIfNeeded()
        
        let token = try getAccessToken()

        let request = buildRequest(withToken: token)
        
        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: request)
        
        self.webSocketTask = task
        task.resume()
        
        listen()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        
        webSocketTask = nil
    }
    
    func send<T: Codable>(_ message: SocketMessage<T>) throws {
        let data = try JSONEncoder().encode(message)
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw SocketManagerError.encodingFailed
        }
        
        let wsMessage = URLSessionWebSocketTask.Message.string(string)
        webSocketTask?.send(wsMessage) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
    }
    
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                
                self?.disconnect()
                
                self?.scheduleReconnect()
            case .success(let message):
                if case .data(let data) = message,
                   let decodedMessage = try? JSONDecoder().decode(SocketMessage<AnyCodable>.self, from: data) {
                       self?.messageSubject.send(decodedMessage)
                    print(decodedMessage.data.value)
                }
                self?.listen() // Listen again
            }
        }
    }
    
    private func refreshTokenIfNeeded() async throws {
        let token = try getAccessToken()
        
        if token.isJWTExpired {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                tokenRefresher
                    .refreshTokenIfNeeded()
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        case .finished:
                            continuation.resume()
                        }
                    }, receiveValue: { })
                    .store(in: &cancellables)
            }
        }
    }
    
    private func getAccessToken() throws -> String {
        try keychainService.loadAuthTokens().authToken
    }
    
    private func buildRequest(withToken token: String) -> URLRequest {
        var request = URLRequest(url: configuration.url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func scheduleReconnect(delay: TimeInterval = 2) {
        print("🔄 Scheduling reconnect in \(delay) seconds")

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            Task {
                do {
                    try await self?.connect()
                    print("✅ Reconnected WebSocket")
                } catch {
                    print("❌ Reconnect failed: \(error)")
                    // Optionally back off further:
                    self?.scheduleReconnect(delay: min(delay * 2, 60))
                }
            }
        }
    }
}
