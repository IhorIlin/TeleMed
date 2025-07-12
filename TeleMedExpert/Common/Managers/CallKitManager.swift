//
//  CallKitManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.07.2025.
//

import Foundation

import Foundation
import CallKit

final class CallKitManager: NSObject, CallManaging {
    private let provider: CXProvider

    override init() {
        let config = CXProviderConfiguration()
        config.includesCallsInRecents = true
        config.supportsVideo = true
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]

        self.provider = CXProvider(configuration: config)

        super.init()
        self.provider.setDelegate(self, queue: nil)
    }

    func reportIncomingCall(payload: VoIPNotificationPayload) {
        let uuid = payload.callId

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: payload.callerName)
        update.hasVideo = payload.callType == .video
        update.localizedCallerName = payload.callerName

        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("❌ CallKit report error: \(error)")
            } else {
                print("✅ CallKit incoming call reported")
            }
        }
    }

    func endCall(uuid: UUID) {
        let action = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: action)

        let controller = CXCallController()
        controller.request(transaction) { error in
            if let error = error {
                print("❌ Failed to end call: \(error)")
            } else {
                print("✅ Call ended via CallKit")
            }
        }
    }
}

extension CallKitManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("CallKit provider reset.")
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("✅ User answered the call.")
        action.fulfill()
        // inform WebRTC or backend to proceed
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("✅ User ended the call.")
        action.fulfill()
        // inform WebRTC or backend to hang up
    }
}
