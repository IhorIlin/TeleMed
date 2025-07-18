//
//  CallEngineDelegate.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation
import WebRTC

protocol CallEngineDelegate: AnyObject {
    func localVideoView() -> RTCVideoRenderer
    func remoteVideoView() -> RTCVideoRenderer
}
