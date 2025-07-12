//
//  SocketMessage.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct SocketMessage<T: Codable>: Codable {
    let event: SocketEvent
    let data: T
}
