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
    private let webrtcManager: WebRTCManaging
    
    init(webrtcManager: WebRTCManaging) {
        self.webrtcManager = webrtcManager
    }
    
    func testStartCallPreview(in view: RTCVideoRenderer) {
        self.webrtcManager.startLocalVideo(in: view)
        self.webrtcManager.startLocalAudio()
    }
}
