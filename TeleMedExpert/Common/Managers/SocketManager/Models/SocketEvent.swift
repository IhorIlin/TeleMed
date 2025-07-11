//
//  SocketEvent.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

enum SocketEvent: String, Codable {
    case ping
    case offer
    case answer
    case iceCandidate
    case endCall
    case error
}
