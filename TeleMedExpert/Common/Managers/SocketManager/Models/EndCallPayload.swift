//
//  EndCallPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct EndCallPayload: Codable {
    let callId: UUID
    let senderId: UUID
    let receiverId: UUID
    let reason: EndCallReason
}
