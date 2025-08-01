//
//  DefaultCallEngine.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 17.07.2025.
//

import Foundation
import Combine
import WebRTC

enum CallEngineEvent {
    case incomingCall
    case incomingCallInApp
    case callDeclined
    case callEnded
}

final class DefaultCallEngine: NSObject, CallEngine {
    private let callClient: CallClient
    private let socketManager: SocketManager
    private let pushService: PushService
    private let callKitManager: CallKitManager
    
    private var call: Call?
    private var webRTCManager: WebRTCManager?
    
    weak var delegate: CallEngineDelegate?
    
    var eventPublisher: AnyPublisher<CallEngineEvent, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let subject = PassthroughSubject<CallEngineEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(callClient: CallClient,
         socketManager: SocketManager,
         pushService: PushService,
         callKitManager: CallKitManager) {
        self.callClient = callClient
        self.socketManager = socketManager
        self.pushService = pushService
        self.callKitManager = callKitManager
        
        super.init()
        
        bindPushService()
        bindCallKitManager()
        bindSocketManager()
    }
    
    func startCall(_ configuration: CallConfiguration) {
        let dto = StartCallRequest(calleeId: configuration.calleeId,
                                   callType: configuration.callType)
        
        let configuration = WebRTCConfiguration(isMicrophoneEnabled: true,
                                                isCameraEnabled: true,
                                                isAudioOnly: configuration.callType == .audio ? true : false)
        
        initWebRTCManager(with: configuration)
        
        callClient.startCall(dto: dto)
            .sink { completion in
                // TODO: - handle possible errors!
            } receiveValue: { response in
                self.call = Call(callId: response.callId,
                                 callerId: response.callerId,
                                 calleeId: response.calleeId,
                                 callType: response.callType,
                                 isIncoming: false)

            }
            .store(in: &cancellables)
    }
    
    func acceptCall() {
        let configuration = WebRTCConfiguration(isMicrophoneEnabled: true,
                                                isCameraEnabled: true,
                                                isAudioOnly: call?.callType == .audio ? true : false)
        
        initWebRTCManager(with: configuration)
        
        webRTCManager?.setupPeerConnectionAndMedia()
        
        sendReadyToOffer()
    }
    
    func declineCall() {
        
    }
    
    func endCall() {
        sendEndCall(reason: .userLeft)
        
        call = nil
        
        webRTCManager?.terminate()
        
        webRTCManager = nil
    }
    
    func switchCamera() {
        webRTCManager?.switchCamera()
    }
    
    func onOffMicrophone() {
        webRTCManager?.toggleMicrophone()
    }
    
    func onOffCamera() {
        webRTCManager?.toggleCamera()
    }
    
    private func initWebRTCManager(with configuration: WebRTCConfiguration) {
        webRTCManager = DefaultWebRTCManager(configuration: configuration)
        
        webRTCManager?.localVideoView = delegate?.localVideoRenderer()
        webRTCManager?.remoteVideoView = delegate?.remoteVideoRenderer()
        
        bindWebRTCManager()
    }
}

// MARK: - Binding -
extension DefaultCallEngine {
    private func bindPushService() {
        pushService.voipPushPublisher
            .sink { [weak self] payload in
                guard let self else { return }
                
                self.call = Call(callId: payload.callId,
                                 callerId: payload.callerId,
                                 calleeId: payload.calleeId,
                                 callType: payload.callType,
                                 isIncoming: true)
                
                self.callKitManager.reportIncomingCall(payload: payload)
            }
            .store(in: &cancellables)
    }
    
    private func bindCallKitManager() {
        callKitManager.publisher
            .sink { [weak self] event in
                switch event {
                case .ringing:
                    self?.subject.send(.incomingCall)
                case .ringingInApp:
                    self?.subject.send(.incomingCallInApp)
                case .accepted:
                    let configuration = WebRTCConfiguration(isMicrophoneEnabled: true,
                                                            isCameraEnabled: true,
                                                            isAudioOnly: self?.call?.callType == .audio ? true : false)
                    
                    self?.initWebRTCManager(with: configuration)
                    
                    self?.webRTCManager?.setupPeerConnectionAndMedia()
                    
                    self?.sendReadyToOffer()
                case .declined:
                    self?.declineCall()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSocketManager() {
        socketManager.messagePublisher
            .sink { [weak self] message in
                switch message.event {
                case .redyToOffer:
                    self?.webRTCManager?.setupPeerConnectionAndMedia()
                    
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
    
    private func bindWebRTCManager() {
        webRTCManager?.eventPublisher
            .sink { event in
                switch event {
                case .iceDiscovered(let candidate):
                    self.sendIceCandidate(candidate: candidate)
                case .error(let error):
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Socket signalling -
extension DefaultCallEngine {
    private func sendReadyToOffer() {
        guard let call = call else { return }
        
        let payload = ReadyToOfferPayload(callId: call.callId,
                                          callerId: call.callerId,
                                          calleeId: call.calleeId,
                                          callType: call.callType)
        
        let message = SocketMessage(event: .redyToOffer, data: payload)
        
        do {
            try socketManager.send(message)
        } catch {
            print("❌ Failed to send readyToOffer: \(error)")
        }
    }
    
    private func sendOffer() {
        webRTCManager?.createOffer { [weak self] sdpString in
            guard let self, let currentCall = self.call, let sdp = sdpString else { return }
            
            let offer = OfferPayload(callId: currentCall.callId,
                                     callerId: currentCall.callerId,
                                     calleeId: currentCall.calleeId,
                                     callType: currentCall.callType,
                                     sdp: sdp)
            
            let message = SocketMessage(event: .offer, data: offer)
            
            do {
                try self.socketManager.send(message)
            } catch {
                preconditionFailure("❌ Failed to send offer: \(error)")
            }
        }
    }
    
    private func sendAnswer() {
        webRTCManager?.createAnswer { [weak self] answer in
            guard let sdp = answer, let self, let currentCall = call else { return }
            
            let payload = AnswerPayload(callerId: currentCall.callerId,
                                        calleeId: currentCall.calleeId,
                                        callType: currentCall.callType,
                                        sdp: sdp)
            
            let message = SocketMessage(event: .answer, data: payload)
            
            do {
                try self.socketManager.send(message)
            } catch {
                print("❌ Failed to send answer: \(error)")
            }
        }
    }
    
    private func sendEndCall(reason: EndCallReason) {
        guard let call = call else { return }
        
        let payload = EndCallPayload(callId: call.callId,
                                     senderId: call.senderId(),
                                     receiverId: call.receiverId(),
                                     reason: reason)
        
        let message = SocketMessage(event: .endCall, data: payload)
        
        do {
            try socketManager.send(message)
        } catch {
            print("❌ Failed to send endCall: \(error)")
        }
    }
    
    private func sendIceCandidate(candidate: RTCIceCandidate) {
        guard let call = self.call else { return }
        
        let iceCandidatePayload = IceCandidatePayload(senderId: call.senderId(),
                                                      receiverId: call.receiverId(),
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
    
    private func handleAnswer(message: SocketMessage<AnyCodable>) {
        guard let sdp = message.data.decode(AnswerPayload.self)?.sdp else {
            preconditionFailure("\(#function) can't decode AnswerPayload")
        }
        
        webRTCManager?.set(remoteAnswer: sdp) { success in
            print("setRemoteOffer - \(success)")
        }
    }
    
    private func handleOffer(message: SocketMessage<AnyCodable>) {
        guard let sdp = message.data.decode(OfferPayload.self)?.sdp else {
            print("\(#function) can't decode OfferPayload")
            return
        }
        
        webRTCManager?.set(remoteOffer: sdp) { [weak self] success in
            print("setRemoteOffer - \(success)")
            self?.sendAnswer()
        }
    }
    
    private func handleEndCall(message: SocketMessage<AnyCodable>) {
        call = nil
        
        webRTCManager?.terminate()
        
        webRTCManager = nil
        
        subject.send(.callEnded)
    }
    
    private func handleIceCandidate(message: SocketMessage<AnyCodable>) {
        guard let iceCandidate = message.data.decode(IceCandidatePayload.self) else {
            print("\(#function) can't decode IceCandidatePayload")
            return
        }
        
        webRTCManager?.addIceCandidate(iceCandidate)
    }
    
    private func handleError(message: SocketMessage<AnyCodable>) {
        
    }
    
    private func handlePing(message: SocketMessage<AnyCodable>) {
        print("Socket event = \(message.event) message = \(message.data.value)")
    }
}
