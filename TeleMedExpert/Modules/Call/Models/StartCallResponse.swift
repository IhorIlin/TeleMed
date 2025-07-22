//
//  StartCallResponse.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 09.07.2025.
//

import Foundation

struct StartCallResponse: Codable {
    let callId: UUID
    let callerId: UUID
    let calleeId: UUID
    let callType: CallType
}
