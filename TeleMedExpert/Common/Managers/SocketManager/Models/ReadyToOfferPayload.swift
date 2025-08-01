//
//  ReadyToOfferPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation

struct ReadyToOfferPayload: Codable {
    let callId: UUID
    let callerId: UUID
    let calleeId: UUID
    let callType: CallType
}
