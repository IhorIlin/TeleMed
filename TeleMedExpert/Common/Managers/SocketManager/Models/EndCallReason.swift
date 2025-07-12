//
//  EndCallReason.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

enum EndCallReason: String, Codable {
    case userLeft = "User hung up the phone"
    case networkError = "Call ended due to network issues"
    case rejected = "User rejected the call"
    case busy = "User is busy"
    case timeout = "Call timed out"
    case unknown = "Call ended for unknown reason"
}
