//
//  DefaultAPNSClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 26.06.2025.
//

import Foundation
import Combine

final class DefaultAPNSClient: APNSClient {
    private let protectedNetworkClient: any ProtectedNetworkClient
    
    init(protectedNetworkClient: any ProtectedNetworkClient) {
        self.protectedNetworkClient = protectedNetworkClient
    }
    
    func registerAPNsDeviceToken(with request: RegisterDeviceTokenDTO) -> AnyPublisher<RegisterDeviceTokenResponse, NetworkClientError> {
        let endpoint = DeviceTokenEndpoint.registerDeviceToken(request)
        
        return protectedNetworkClient.request(endpoint: endpoint).eraseToAnyPublisher()
    }
    
    func registerVoIPDeviceToken(with request: RegisterDeviceTokenDTO) -> AnyPublisher<RegisterDeviceTokenResponse, NetworkClientError> {
        let endpoint = DeviceTokenEndpoint.registerDeviceToken(request)
        
        return protectedNetworkClient.request(endpoint: endpoint).eraseToAnyPublisher()
    }
}
