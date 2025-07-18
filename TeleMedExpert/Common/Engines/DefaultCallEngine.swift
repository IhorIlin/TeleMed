//
//  DefaultCallEngine.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation
import Combine
import WebRTC

final class DefaultCallEngine: CallEngine {
    private let webRTCManager: WebRTCManager
    private let socketManager: SocketManager
    
    weak var delegate: CallEngineDelegate?
    
    init(webRTCManager: WebRTCManager, socketManager: SocketManager) {
        self.webRTCManager = webRTCManager
        self.socketManager = socketManager
    }
    
    func startCall() {
        
    }
    
    func receiveCall() {
        
    }
    
    func acceptCall() {
        
    }
    
    func declineCall() {
        
    }
    
    func switchCamera() {
        
    }
    
    func onOffMicrophone() {
        
    }
    
    func onOffCamera() {
        
    }
}
