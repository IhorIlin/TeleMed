//
//  APNSClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 26.06.2025.
//

import Combine
import Foundation

protocol APNSClient {
    func registerAPNsDeviceToken(with request: RegisterDeviceTokenDTO) -> AnyPublisher<EmptyResponse, NetworkClientError>
    func registerVoIPDeviceToken(with request: RegisterDeviceTokenDTO) -> AnyPublisher<EmptyResponse, NetworkClientError>
}
