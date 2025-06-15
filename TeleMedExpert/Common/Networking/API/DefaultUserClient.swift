//
//  DefaultUserClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.06.2025.
//

import Foundation
import Combine

final class DefaultUserClient: NetworkClient {
    // TODO: inject refresh token network client
    init() {
        
    }
    
    func request<T>(endpoint: any Endpoint) -> AnyPublisher<T, NetworkClientError> where T : Decodable {
        
    }
}
