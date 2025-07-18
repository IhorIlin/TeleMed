//
//  DefaultWebRTCManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Foundation
import WebRTC
import UIKit
import Combine

final class DefaultWebRTCManager: NSObject, WebRTCManager {
    private let factory: RTCPeerConnectionFactory
    private var peerConnection: RTCPeerConnection?
    
    private var localVideoTrack: RTCVideoTrack?
    private var localAudioTrack: RTCAudioTrack?
    
    private var videoCapturer: RTCCameraVideoCapturer?
    
    private let iceServers: [RTCIceServer] = [
        RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])
    ]
    
    // MARK: - Init
    
    override init() {
        RTCInitializeSSL()
        self.factory = RTCPeerConnectionFactory()
        super.init()
    }
    
    // MARK: - Local Video
    
    func startLocalVideo(in view: RTCVideoRenderer) {
        let videoSource = factory.videoSource()
        let capturer = RTCCameraVideoCapturer(delegate: videoSource)
        self.videoCapturer = capturer
        
        let videoTrack = factory.videoTrack(with: videoSource, trackId: "ARDAMSv0")
        self.localVideoTrack = videoTrack
        videoTrack.add(view)
        
        guard
            let device = RTCCameraVideoCapturer.captureDevices().first,
            let format = device.formats.first,
            let fps = format.videoSupportedFrameRateRanges.first?.maxFrameRate
        else {
            print("⚠️ No camera device available.")
            return
        }
        
        capturer.startCapture(with: device, format: format, fps: Int(fps))
    }
    
    func stopLocalVideo() {
        videoCapturer?.stopCapture()
    }
    
    func startLocalAudio() {
        let audioTrack = factory.audioTrack(withTrackId: "ARDAMSa0")
        self.localAudioTrack = audioTrack
    }
    
    // MARK: - Peer Connection
    
    func createPeerConnection(delegate: RTCPeerConnectionDelegate) {
        let config = RTCConfiguration()
        config.iceServers = iceServers
        
        let constraints = RTCMediaConstraints(
            mandatoryConstraints: nil,
            optionalConstraints: nil
        )
        
        peerConnection = factory.peerConnection(
            with: config,
            constraints: constraints,
            delegate: delegate
        )
        
        print("✅ Peer connection created.")
    }
    
    func addLocalTracks() {
        guard let peerConnection = peerConnection else {
            print("⚠️ Peer connection not yet created.")
            return
        }
        
        if let videoTrack = localVideoTrack {
            peerConnection.add(videoTrack, streamIds: ["stream0"])
        }
        
        if let audioTrack = localAudioTrack {
            peerConnection.add(audioTrack, streamIds: ["stream0"])
        }
        
        print("✅ Local tracks added to peer connection.")
    }
    
    // MARK: - Offer/Answer
    
    func createOffer(completion: @escaping (String?) -> Void) {
        let constraints = RTCMediaConstraints(
            mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"],
            optionalConstraints: nil
        )
        
        peerConnection?.offer(for: constraints) { [weak self] sdp, error in
            if let error = error {
                print("❌ Failed to create offer: \(error)")
                completion(nil)
                return
            }
            
            guard let sdp = sdp else {
                completion(nil)
                return
            }
            
            self?.peerConnection?.setLocalDescription(sdp) { error in
                if let error = error {
                    print("❌ Failed to set local description: \(error)")
                    completion(nil)
                    return
                }
                
                print("✅ Local SDP offer set.")
                completion(sdp.sdp)
            }
        }
    }
    
    func set(remoteOffer sdpString: String, completion: @escaping (Bool) -> Void) {
        let remoteSDP = RTCSessionDescription(type: .offer, sdp: sdpString)
        peerConnection?.setRemoteDescription(remoteSDP) { error in
            if let error = error {
                print("❌ Failed to set remote offer: \(error)")
                completion(false)
            } else {
                print("✅ Remote offer SDP set.")
                completion(true)
            }
        }
    }
    
    func createAnswer(completion: @escaping (String?) -> Void) {
        let constraints = RTCMediaConstraints(
            mandatoryConstraints: ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"],
            optionalConstraints: nil
        )
        
        peerConnection?.answer(for: constraints) { [weak self] sdp, error in
            if let error = error {
                print("❌ Failed to create answer: \(error)")
                completion(nil)
                return
            }
            
            guard let sdp = sdp else {
                completion(nil)
                return
            }
            
            self?.peerConnection?.setLocalDescription(sdp) { error in
                if let error = error {
                    print("❌ Failed to set local description: \(error)")
                    completion(nil)
                    return
                }
                
                print("✅ Local SDP answer set.")
                completion(sdp.sdp)
            }
        }
    }
    
    func set(remoteAnswer sdpString: String, completion: @escaping (Bool) -> Void) {
        let remoteSDP = RTCSessionDescription(type: .answer, sdp: sdpString)
        peerConnection?.setRemoteDescription(remoteSDP) { error in
            if let error = error {
                print("❌ Failed to set remote answer: \(error)")
                completion(false)
            } else {
                print("✅ Remote answer SDP set.")
                completion(true)
            }
        }
    }
    
    // MARK: - ICE
    
    func addIceCandidate(_ candidate: IceCandidatePayload) {
        let rtcCandidate = RTCIceCandidate(
            sdp: candidate.candidate,
            sdpMLineIndex: Int32(candidate.sdpMLineIndex ?? 0),
            sdpMid: candidate.sdpMid
        )
        
        peerConnection?.add(rtcCandidate) { error in
            if let error = error {
                print("❌ Failed to set IceCandidate: \(error)")
                return
            }
            
            print("✅ Added ICE candidate.")
        }
    }
}

