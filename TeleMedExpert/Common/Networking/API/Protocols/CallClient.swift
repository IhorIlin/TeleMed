//
//  CallClient.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 09.07.2025.
//

import Foundation
import Combine

protocol CallClient {
    func startCall(dto: StartCallRequestDTO) -> AnyPublisher<StartCallResponseDTO, NetworkClientError>
}
