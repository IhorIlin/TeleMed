//
//  PushManaging.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation
import Combine
import PushKit
import UserNotifications

enum PushPermissionError: Error {
    case notDetermined
    case denied
    case authorized
    case provisional
    case ephemeral
    case systemError(Error)
}

protocol PushManaging {
    func requestNotificationPermission() -> AnyPublisher<Void, PushPermissionError>
    func registerRegularToken(_ token: Data)
    func registerVoIPToken(_ token: Data)
    func handleVoIPPayload(_ payload: PKPushPayload)
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any])
}
