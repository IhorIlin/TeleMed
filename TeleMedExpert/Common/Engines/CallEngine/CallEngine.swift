//
//  CallEngine.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation
import WebRTC
import Combine

protocol CallEngine {
    var eventPublisher: AnyPublisher<CallEngineEvent, Never> { get }
    var delegate: CallEngineDelegate? { get set }
    func startCall(_ configuration: CallConfiguration)
    // Call screen UI related methods
    func acceptCall()
    func declineCall()
    func switchCamera()
    func onOffMicrophone()
    func onOffCamera()
}
