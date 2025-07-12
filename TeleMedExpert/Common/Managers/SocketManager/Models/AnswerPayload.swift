//
//  AnswerPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct AnswerPayload: Codable {
    let callerId: UUID
    let calleeId: UUID
    let callType: CallType
    let sdp: String
}
