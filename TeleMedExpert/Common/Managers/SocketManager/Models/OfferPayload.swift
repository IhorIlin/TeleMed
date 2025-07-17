//
//  OfferPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct OfferPayload: Codable {
    let callerId: UUID
    let calleeId: UUID
    let callId: UUID
    let callType: CallType
    let sdp: String
}
