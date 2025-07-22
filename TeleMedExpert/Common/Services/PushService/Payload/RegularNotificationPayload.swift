//
//  RegularNotificationPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 18.07.2025.
//

import Foundation

struct AppleAlert: Codable {
    let title: String
    let body: String
}

struct AppleAPS: Codable {
    let alert: AppleAlert
    let sound: String
}

struct RegularNotificationPayload: Codable {
    let aps: AppleAPS
    let type: String
    let data: [String: String]?
    let messageId: String?
    let userId: String?
}
