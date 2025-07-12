//
//  VoIPNotificationPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.07.2025.
//

import Foundation

struct VoIPNotificationPayload: Codable {
    let callId: UUID
    let callerId: UUID
    let callerName: String
    let callerNumber: String
    let calleeId: UUID
    let callType: CallType
    let timestamp: Double
    
    init(
        callId: UUID,
        callerId: UUID,
        callerName: String,
        callerNumber: String,
        calleeId: UUID,
        callType: CallType,
        timestamp: Double
    ) {
        self.callId = callId
        self.callerId = callerId
        self.callerName = callerName
        self.callerNumber = callerNumber
        self.calleeId = calleeId
        self.callType = callType
        self.timestamp = timestamp
    }
}
