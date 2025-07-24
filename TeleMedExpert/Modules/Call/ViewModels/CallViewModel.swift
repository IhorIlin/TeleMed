//
//  CallViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Combine
import Foundation
import WebRTC

final class CallViewModel: ObservableObject {
    private var callEngine: CallEngine
    private let callConfiguration: CallConfiguration?
    
    weak var callEngineDelegate: CallEngineDelegate? {
        set {
            callEngine.delegate = newValue
        }
        get {
            callEngine.delegate
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(callEngine: CallEngine, callConfiguration: CallConfiguration?) {
        self.callEngine = callEngine
        self.callConfiguration = callConfiguration
    }
    
    func processCall() {
        if let config = callConfiguration {
            callEngine.startCall(config)
        }
    }
    
    deinit {
        print("CallViewModel deinited!")
    }
}

// MARK: - User actions -
extension CallViewModel {
    func acceptCall() {
        callEngine.acceptCall()
    }
    
    func endCall() {
        callEngine.endCall()
    }
    
    func declineCall() {
        callEngine.declineCall()
    }
    
    func manageMicrophone() {
        callEngine.onOffMicrophone()
    }
    
    func manageCamera() {
        callEngine.onOffCamera()
    }
    
    func switchCamera() {
        
    }
}

