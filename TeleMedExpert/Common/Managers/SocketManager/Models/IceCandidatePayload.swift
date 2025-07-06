//
//  IceCandidatePayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct IceCandidatePayload: Codable {
    let senderId: UUID
    let receiverId: UUID
    let candidate: String
    let sdpMid: String?
    let sdpMLineIndex: Int?
}
