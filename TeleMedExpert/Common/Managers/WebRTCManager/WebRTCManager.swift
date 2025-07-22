//
//  WebRTCManager.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Combine
import WebRTC

protocol WebRTCManager {
    func startLocalVideo(in view: RTCVideoRenderer)
    func stopLocalVideo()
    func startLocalAudio()
    
    func createPeerConnection(delegate: RTCPeerConnectionDelegate)
    func addLocalTracks()
    
    func createOffer(completion: @escaping (String?) -> Void)
    func set(remoteOffer sdpString: String, completion: @escaping (Bool) -> Void)
    
    func createAnswer(completion: @escaping (String?) -> Void)
    func set(remoteAnswer sdpString: String, completion: @escaping (Bool) -> Void)
    
    func addIceCandidate(_ candidate: IceCandidatePayload)
}
