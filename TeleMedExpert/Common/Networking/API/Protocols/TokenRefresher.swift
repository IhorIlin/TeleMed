//
//  TokenRefresher.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 15.06.2025.
//

import Foundation
import Combine

protocol TokenRefresher {
    func refreshTokenIfNeeded() -> AnyPublisher<Void, NetworkClientError>
}
