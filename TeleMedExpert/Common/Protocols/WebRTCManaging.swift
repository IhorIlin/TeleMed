//
//  WebRTCManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Combine
import WebRTC

protocol WebRTCManaging {
    var localVideoPublisher: AnyPublisher<RTCVideoTrack?, Never> { get }
    func startLocalVideo(in view: RTCVideoRenderer)
    func stopLocalVideo()
    func startLocalAudio()
}
