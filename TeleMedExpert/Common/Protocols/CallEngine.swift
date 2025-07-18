//
//  CallEngine.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation
import WebRTC

protocol CallEngine {
    func startCall()
    func receiveCall()
    // Call screen UI related methods
    func acceptCall()
    func declineCall()
    func switchCamera()
    func onOffMicrophone()
    func onOffCamera()
}
