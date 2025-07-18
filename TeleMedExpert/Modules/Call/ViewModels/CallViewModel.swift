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
    private var callDTO: StartCallRequestDTO
    private let webRTCManager: WebRTCManager
    private let socketManager: SocketManager
    private let callClient: CallClient
    private let sessionService: SessionService
    private let callKitManager: CallKitManager
    
    var remoteVideoPublisher: AnyPublisher<RTCVideoTrack?, Never> {
        remoteVideoSubject.eraseToAnyPublisher()
    }
    
    private let remoteVideoSubject = CurrentValueSubject<RTCVideoTrack?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(callDTO: StartCallRequestDTO,
         webRTCManager: WebRTCManager,
         socketManager: SocketManager,
         callClient: CallClient,
         sessionService: SessionService,
         callKitManager: CallKitManager) {
        self.callDTO = callDTO
        self.webRTCManager = webRTCManager
        self.socketManager = socketManager
        self.callClient = callClient
        self.sessionService = sessionService
        self.callKitManager = callKitManager
        
        super.init()
        
        bindSocket()
        
        bindCallKitManager()
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
                case .redyToOffer:
                    self?.sendOffer()
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
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCallKitManager() {
        callKitManager.publisher
            .sink { [weak self] action in
                switch action {
                case .ringing:
                    break
                case .accepted:
                    break
                case .declined:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Signalling -
extension CallViewModel {
    private func handleOffer(message: SocketMessage<AnyCodable>) {
        guard let sdp = message.data.decode(OfferPayload.self)?.sdp else {
            print("\(#function) can't decode OfferPayload")
            return
        }
        
        webRTCManager.set(remoteOffer: sdp) { [weak self] success in
            print("setRemoteOffer - \(success)")
            self?.sendAnswer()
        }
    }
    
    private func handleAnswer(message: SocketMessage<AnyCodable>) {
        guard let sdp = message.data.decode(AnswerPayload.self)?.sdp else {
            print("\(#function) can't decode AnswerPayload")
            return
        }
        
        webRTCManager.set(remoteAnswer: sdp) { success in
            print("setRemoteOffer - \(success)")
        }
    }
    
    private func handleIceCandidate(message: SocketMessage<AnyCodable>) {
        guard let iceCandidate = message.data.decode(IceCandidatePayload.self) else {
            print("\(#function) can't decode IceCandidatePayload")
            return
        }
        
        webRTCManager.addIceCandidate(iceCandidate)
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
                self?.callDTO.callId = response.callId
                print("Call record created: callId = \(response.callId)")
            }
            .store(in: &cancellables)
    }
    
    private func sendOffer() {
        self.webRTCManager.createPeerConnection(delegate: self)
        
        self.webRTCManager.createOffer { [weak self] sdpString in
            guard let self, let callId = self.callDTO.callId, let sdp = sdpString else { return }
            
            do {
                let offer = OfferPayload(callerId: self.sessionService.currentUser.id,
                                         calleeId: self.callDTO.calleeId,
                                         callId: callId,
                                         callType: .video,
                                         sdp: sdp)
                
                try self.socketManager.send(SocketMessage(event: .offer, data: offer))
            } catch {
                print("❌ Failed to send offer: \(error)")
            }
        }
    }
    
    private func sendReadyToOffer(payload: VoIPNotificationPayload) {
        webRTCManager.createPeerConnection(delegate: self)
        let payload = ReadyToOfferPayload(callId: payload.callId,
                                          callerId: payload.callerId,
                                          calleeId: payload.calleeId,
                                          callType: payload.callType)
        
        let message = SocketMessage(event: .redyToOffer, data: payload)
        do {
            try socketManager.send(message)
        } catch {
            print("❌ Failed to send readyToOffer: \(error)")
        }
    }
    
    private func sendAnswer() {
        webRTCManager.createAnswer { [weak self] answer in
            guard let sdp = answer, let self else { return }
            
            let payload = AnswerPayload(callerId: callDTO.calleeId, calleeId: callDTO.calleeId, callType: callDTO.callType, sdp: sdp)
            let message = SocketMessage(event: .answer, data: payload)
            
            do {
                try self.socketManager.send(message)
            } catch {
                print("❌ Failed to send answer: \(error)")
            }
        }
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
        
        let iceCandidatePayload = IceCandidatePayload(senderId: sessionService.currentUser.id,
                                                      receiverId: callDTO.calleeId != sessionService.currentUser.id ? callDTO.calleeId : sessionService.currentUser.id,
                                                      candidate: candidate.sdp,
                                                      sdpMid: candidate.sdpMid,
                                                      sdpMLineIndex: Int(candidate.sdpMLineIndex))
        
        let message = SocketMessage(event: .iceCandidate, data: iceCandidatePayload)
        
        do {
            try socketManager.send(message)
        } catch {
            print("Send ice candidate error - \(error.localizedDescription)")
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("Signaling state changed: \(stateChanged)")
    }
}

