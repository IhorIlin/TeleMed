//
//  CallViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Combine
import Foundation
import WebRTC

final class CallViewModel: NSObject, ObservableObject {
    private let webRTCManager: WebRTCManaging
    private let socketManager: SocketManaging
    
    var remoteVideoPublisher: AnyPublisher<RTCVideoTrack?, Never> {
        remoteVideoSubject.eraseToAnyPublisher()
    }
    
    private let remoteVideoSubject = CurrentValueSubject<RTCVideoTrack?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(webRTCManager: WebRTCManaging, socketManager: SocketManaging) {
        self.webRTCManager = webRTCManager
        self.socketManager = socketManager
    }
    
    func testStartCallPreview(in view: RTCVideoRenderer) {
        self.webRTCManager.startLocalVideo(in: view)
        self.webRTCManager.startLocalAudio()
    }
}

// MARK: - RTCPeerConnectionDelegate -

extension CallViewModel: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        print("didRemove stream: \(stream)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("didChange newState: RTCIceConnectionState - \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("didChange newState: RTCIceGatheringState - \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("didRemove candidates: [RTCIceCandidate] - \(candidates)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("didOpen dataChannel: RTCDataChannel - \(dataChannel)")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        print("peerConnectionShouldNegotiate: \(peerConnection)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        if let remoteVideoTrack = stream.videoTracks.first {
            remoteVideoSubject.send(remoteVideoTrack)
            print("✅ Remote video track added.")
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("✅ ICE Candidate discovered: \(candidate.sdp)")
        
        // TODO: send ICE to backend via WebSocket
        let payload = IceCandidatePayload(senderId: <#T##UUID#>, receiverId: <#T##UUID#>, candidate: <#T##String#>, sdpMid: <#T##String?#>, sdpMLineIndex: <#T##Int?#>)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("Signaling state changed: \(stateChanged)")
    }
}

