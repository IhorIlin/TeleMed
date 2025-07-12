//
//  CallManaging.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.07.2025.
//

import Foundation
import CallKit

protocol CallManaging {
    func reportIncomingCall(payload: VoIPNotificationPayload)
    func endCall(uuid: UUID)
}
