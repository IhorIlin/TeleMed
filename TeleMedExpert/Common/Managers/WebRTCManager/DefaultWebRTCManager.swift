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
import AVFoundation

final class DefaultWebRTCManager: NSObject, WebRTCManager {
    var eventPublisher: AnyPublisher<WebRTCEvent, Never> {
        subject.eraseToAnyPublisher()
    }
    private var subject = PassthroughSubject<WebRTCEvent, Never>()
    
    var localVideoView: (any RTCVideoRenderer)?
    var remoteVideoView: (any RTCVideoRenderer)?
    
    private let factory: RTCPeerConnectionFactory
    
    private var peerConnection: RTCPeerConnection?
    private let configuration: WebRTCConfiguration
    
    private var localVideoTrack: RTCVideoTrack?
    private var localAudioTrack: RTCAudioTrack?
   
    private var remoteVideoTrack: RTCVideoTrack?

    private var videoCapturer: RTCCameraVideoCapturer?
    
    private let iceServers: [RTCIceServer] = [
        RTCIceServer(
                urlStrings: ["turn:135.181.151.209:3478"],
                username: "testuser",
                credential: "testpassword",
                tlsCertPolicy: .insecureNoCheck
            ),
        RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])
    ]
    
    // MARK: - Init
    
    init(configuration: WebRTCConfiguration) {
        self.configuration = configuration
        
        RTCInitializeSSL()
        
        self.factory = RTCPeerConnectionFactory()
        
        super.init()
    }
    
    func setupPeerConnectionAndMedia() {
        createPeerConnection(delegate: self)
        
        configureLocalAudio()
        
        configureLocalVideo()
        
        addLocalTracks()
    }
    
    func toggleSpeaker() {
        
    }
    
    func toggleMicrophone() {
        localAudioTrack?.isEnabled.toggle()
    }
    
    func toggleCamera() {
        localVideoTrack?.isEnabled.toggle()
    }
    
    func switchCamera() {
        guard let capturer = videoCapturer,
              let currentInput = capturer.captureSession.inputs.compactMap({ $0 as? AVCaptureDeviceInput }).first else {
            print("⚠️ No active capturer or current device input.")
            return
        }

        let currentPosition = currentInput.device.position
        let newPosition: AVCaptureDevice.Position = (currentPosition == .front) ? .back : .front

        guard let newDevice = RTCCameraVideoCapturer.captureDevices().first(where: { $0.position == newPosition }) else {
            print("⚠️ No available camera at position: \(newPosition)")
            return
        }

        guard let bestFormat = selectBestFormat(for: newDevice) else {
            print("⚠️ No supported format found for new device")
            return
        }

        // Stop current capture and restart with new device
        capturer.stopCapture {
            capturer.startCapture(with: newDevice, format: bestFormat.format, fps: bestFormat.fps)
            print("🔄 Switched camera to: \(newPosition == .front ? "front" : "back")")
        }
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
    
    func terminate() {
        localVideoView = nil
        remoteVideoView = nil
        remoteVideoTrack = nil
        videoCapturer = nil
        
        stopLocalAudio()
        
        peerConnection?.close()
        peerConnection = nil
    }
}

extension DefaultWebRTCManager {
    private func selectBestFormat(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, fps: Int)? {
        var selectedFormat: AVCaptureDevice.Format?
        var selectedFps: Float64 = 0

        for format in device.formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let maxFps = format.videoSupportedFrameRateRanges.first?.maxFrameRate ?? 0

            // Target resolution: 1280x720 (can change as needed)
            let isHD = dimensions.width == 1280 && dimensions.height == 720
            if isHD && maxFps > selectedFps {
                selectedFormat = format
                selectedFps = maxFps
            }
        }

        // Fallback to the first format if no HD format is found
        if let selected = selectedFormat {
            return (format: selected, fps: Int(selectedFps))
        } else if let fallback = device.formats.first,
                  let fallbackFps = fallback.videoSupportedFrameRateRanges.first?.maxFrameRate {
            return (format: fallback, fps: Int(fallbackFps))
        }

        return nil
    }
    
    private func stopLocalAudio() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            
            print("✅ AVAudioSession disabled.")
        } catch {
            print("❌ Failed to disable AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    private func createPeerConnection(delegate: RTCPeerConnectionDelegate) {
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
    
    private func configureLocalAudio() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .videoChat, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            
            print("✅ AVAudioSession configured.")
        } catch {
            print("❌ Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
        
        let audioTrack = factory.audioTrack(withTrackId: "ARDAMSa0")
        localAudioTrack = audioTrack
        localAudioTrack?.isEnabled = configuration.isMicrophoneEnabled
    }
    
    private func configureLocalVideo() {
        let videoSource = factory.videoSource()
        let capturer = RTCCameraVideoCapturer(delegate: videoSource)
        self.videoCapturer = capturer
        
        let videoTrack = factory.videoTrack(with: videoSource, trackId: "ARDAMSv0")
        self.localVideoTrack = videoTrack
        self.localVideoTrack?.isEnabled = configuration.isCameraEnabled
        
        guard let view = localVideoView else {
            fatalError("No localVideoView for rendering!")
        }
        
        videoTrack.add(view)
        
        guard
            let device = RTCCameraVideoCapturer.captureDevices().first(where: { $0.position == .front })
        else {
            print("⚠️ No camera device available.")
            return
        }
        
        if let result = selectBestFormat(for: device) {
            capturer.startCapture(with: device, format: result.format, fps: result.fps)
        } else {
            fatalError("⚠️ No camera device available.")
        }
    }
    
    private func addLocalTracks() {
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
}

// MARK: - RTCPeerConnectionDelegate -
extension DefaultWebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("\(#function) : \(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("\(#function) : \(stream)")
        
        guard let remoteTrack = stream.videoTracks.first,
              let remoteView = remoteVideoView else {
            print("❌ No remote track or remote view available")
            return
        }
        
        remoteVideoTrack = remoteTrack
        
        DispatchQueue.main.async {
            remoteTrack.add(remoteView)
            remoteTrack.isEnabled = true
            print("✅ Remote video track added to remote view.")
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        print("\(#function) : \(stream)")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        print("\(#function) : \(peerConnection)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("🌐 ICE Connection State changed: \(newState)")
        switch newState {
        case .connected:
            print("connected")
        case .completed:
            print("completed")
        case .closed:
            print("closed")
        case .checking:
            print("checking")
        case .disconnected:
            print("disconected")
        case .failed:
            print("failed")
        case .new:
            print("new")
        default:
            break
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("\(#function) : \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("✅ ICE Candidate discovered: \(candidate.sdp)")
        
        subject.send(.iceDiscovered(candidate))
//        guard let call = self.call else { return }
//        
//        let iceCandidatePayload = IceCandidatePayload(senderId: call.senderId(),
//                                                      receiverId: call.receiverId(),
//                                                      candidate: candidate.sdp,
//                                                      sdpMid: candidate.sdpMid,
//                                                      sdpMLineIndex: Int(candidate.sdpMLineIndex))
//        
//        let message = SocketMessage(event: .iceCandidate, data: iceCandidatePayload)
//        
//        do {
//            try socketManager.send(message)
//        } catch {
//            print("Send ice candidate error - \(error.localizedDescription)")
//        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("\(#function) : \(candidates)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("\(#function) : \(dataChannel)")
    }
}
