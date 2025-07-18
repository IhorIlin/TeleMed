//
//  CallKitManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.07.2025.
//

import Foundation
import CallKit
import Combine

protocol CallKitManager {
    var publisher: AnyPublisher<CallAction, Never> { get }
    func reportIncomingCall(payload: VoIPNotificationPayload)
}
