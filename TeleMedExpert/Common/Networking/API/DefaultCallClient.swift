//
//  DefaultCallClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 09.07.2025.
//

import Foundation
import Combine

final class DefaultCallClient: CallClient {
    private let protectedNetworkClient: ProtectedNetworkClient
    
    init(protectedNetworkClient: ProtectedNetworkClient) {
        self.protectedNetworkClient = protectedNetworkClient
    }
    
    func startCall(dto: StartCallRequest) -> AnyPublisher<StartCallResponse, NetworkClientError> {
        let enpoint = CallEndpoint.startCall(dto: dto)
        
        return protectedNetworkClient.request(endpoint: enpoint).eraseToAnyPublisher()
    }
}
