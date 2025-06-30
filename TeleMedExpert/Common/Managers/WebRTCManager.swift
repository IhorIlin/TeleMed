//
//  WebRTCManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Foundation
import WebRTC
import UIKit
import Combine

final class WebRTCManager: NSObject, WebRTCManaging {
    // MARK: - Properties
    var localVideoPublisher: AnyPublisher<RTCVideoTrack?, Never> {
        localVideoSubject.eraseToAnyPublisher()
    }
    
    private let localVideoSubject = CurrentValueSubject<RTCVideoTrack?, Never>(nil)
    private let factory: RTCPeerConnectionFactory
    private var localVideoTrack: RTCVideoTrack?
    private var localAudioTrack: RTCAudioTrack?
    private var videoCapturer: RTCCameraVideoCapturer?
    
    private var peerConnection: RTCPeerConnection?
    
    private let iceServers: [RTCIceServer] = [
        RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])
    ]
    
    // MARK: - Init
    
    override init() {
        // Initialize WebRTC factory
        RTCInitializeSSL() // Optional since WebRTC ≥ M96 but safe
        self.factory = RTCPeerConnectionFactory()
        
        super.init()
    }
    
    // MARK: - Local Video
    
    func startLocalVideo(in view: RTCVideoRenderer) {
        let videoSource = factory.videoSource()
        let capturer = RTCCameraVideoCapturer(delegate: videoSource)
        self.videoCapturer = capturer
        
        // Create video track
        let videoTrack = factory.videoTrack(with: videoSource, trackId: "ARDAMSv0")
        self.localVideoTrack = videoTrack
        self.localVideoTrack?.add(view)

        // Publish video track
        localVideoSubject.send(videoTrack)
        
        // Start camera
        guard
            let device = RTCCameraVideoCapturer.captureDevices().first,
            let format = device.formats.first,
            let fps = format.videoSupportedFrameRateRanges.first?.maxFrameRate
        else {
            print("⚠️ No camera device available.")
            return
        }
        
        capturer.startCapture(with: device,
                              format: format,
                              fps: Int(fps))
    }
    
    // MARK: - Local Audio
    
    func startLocalAudio() {
        let audioTrack = factory.audioTrack(withTrackId: "ARDAMSa0")
        self.localAudioTrack = audioTrack
    }
    
    // MARK: - Stop capture
    
    func stopLocalVideo() {
        videoCapturer?.stopCapture()
    }
}
