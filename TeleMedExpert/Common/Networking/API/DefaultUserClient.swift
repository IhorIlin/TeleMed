//
//  DefaultUserClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.06.2025.
//

import Foundation
import Combine

final class DefaultUserClient: UserClient {
    private let protectedNetworkClient: ProtectedNetworkClient
    
    init(protectedNetworkClient: ProtectedNetworkClient) {
        self.protectedNetworkClient = protectedNetworkClient
    }
    
    func getUserProfile() -> AnyPublisher<UserProfileResponseDTO, NetworkClientError> {
        let endpoint = UsersEndpoint.getMe()
        
        return protectedNetworkClient.request(endpoint: endpoint).eraseToAnyPublisher()
    }
}
