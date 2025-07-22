//
//  Call.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 19.07.2025.
//

import Foundation

struct Call {
    let callId: UUID
    let callerId: UUID
    let calleeId: UUID
    let callType: CallType
    let isIncoming: Bool
    
    func receiverId() -> UUID {
        isIncoming ? callerId : calleeId
    }
    
    func senderId() -> UUID {
        isIncoming ? calleeId : callerId
    }
}
