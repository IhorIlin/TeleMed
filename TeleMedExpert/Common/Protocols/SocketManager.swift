//
//  SocketManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation
import Combine

protocol SocketManager {
    var isConnected: Bool { get }
    var messagePublisher: AnyPublisher<SocketMessage<AnyCodable>, Never> { get }
        
    func connect() async throws
    func disconnect()
    func send<T: Codable>(_ message: SocketMessage<T>) throws
        
}
