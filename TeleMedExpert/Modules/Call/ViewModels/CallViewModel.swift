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
    private let callDTO: StartCallRequestDTO
    private let webRTCManager: WebRTCManaging
    private let socketManager: SocketManaging
    private let callClient: CallClient
    private let sessionService: SessionMonitor
    
    var remoteVideoPublisher: AnyPublisher<RTCVideoTrack?, Never> {
        remoteVideoSubject.eraseToAnyPublisher()
    }
    
    private let remoteVideoSubject = CurrentValueSubject<RTCVideoTrack?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(callDTO: StartCallRequestDTO,
         webRTCManager: WebRTCManaging,
         socketManager: SocketManaging,
         callClient: CallClient,
         sessionService: SessionMonitor) {
        self.callDTO = callDTO
        self.webRTCManager = webRTCManager
        self.socketManager = socketManager
        self.callClient = callClient
        self.sessionService = sessionService
        
        super.init()
        
        bindSocket()
    }
    
    func testStartCallPreview(in view: RTCVideoRenderer) {
        self.webRTCManager.startLocalVideo(in: view)
        self.webRTCManager.startLocalAudio()
    }
    
    private func bindSocket() {
        socketManager.messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                switch message.event {
                case .answer:
                    self?.handleAnswer(message: message)
                case .offer:
                    self?.handleOffer(message: message)
                case .endCall:
                    self?.handleEndCall(message: message)
                case .iceCandidate:
                    self?.handleIceCandidate(message: message)
                case .error:
                    self?.handleError(message: message)
                case .ping:
                    self?.handlePing(message: message)
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Signalling -
extension CallViewModel {
    private func handleOffer(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handleAnswer(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handleIceCandidate(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handleEndCall(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handleError(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handlePing(message: SocketMessage<AnyCodable>) {
        print("Socket event = \(message.event) message = \(message.data.value)")
    }
}

// MARK: - Initiate call -
extension CallViewModel {
    func initiateCall() {
        callClient.startCall(dto: callDTO)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Call create finished")
                case .failure(let error):
                    print("Call create error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                
                print("Call record created: callId = \(response.callId)")
                
                self.webRTCManager.createPeerConnection(delegate: self)
                
                self.webRTCManager.createOffer { sdpString in
                    guard let sdp = sdpString else { return }
                    
                    do {
                        let offer = OfferPayload(callerId: self.sessionService.currentUser.id,
                                                 calleeId: self.callDTO.calleeId,
                                                 callType: .video,
                                                 sdp: sdp)
                        
                        try self.socketManager.send(SocketMessage(event: .offer, data: offer))
                    } catch {
                        print("❌ Failed to send offer: \(error)")
                    }
                    
                }
            }
            .store(in: &cancellables)
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
//        let payload = IceCandidatePayload(senderId: <#T##UUID#>, receiverId: <#T##UUID#>, candidate: <#T##String#>, sdpMid: <#T##String?#>, sdpMLineIndex: <#T##Int?#>)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("Signaling state changed: \(stateChanged)")
    }
}

