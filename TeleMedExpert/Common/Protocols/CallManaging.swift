//
//  CallManaging.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.07.2025.
//

import Foundation
import CallKit
import Combine

protocol CallManaging {
    var callerId: UUID { get }
    var calleeId: UUID { get }
    var publisher: AnyPublisher<CallAction, Never> { get }
    func reportIncomingCall(payload: VoIPNotificationPayload)
    func endCall(uuid: UUID)
}
