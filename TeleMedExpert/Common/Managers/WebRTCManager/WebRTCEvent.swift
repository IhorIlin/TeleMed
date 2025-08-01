//
//  WebRTCEvent.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 24.07.2025.
//

import Foundation
import WebRTC

enum WebRTCEvent {
    case iceDiscovered(RTCIceCandidate)
    case error(Error)
}
