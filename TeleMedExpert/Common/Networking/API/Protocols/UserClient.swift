//
//  UserClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.06.2025.
//

import Combine

protocol UserClient {
    func getUserProfile() -> AnyPublisher<UserProfileResponseDTO, NetworkClientError>
}
