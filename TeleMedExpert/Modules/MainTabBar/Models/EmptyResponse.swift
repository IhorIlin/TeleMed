//
//  EmptyResponse.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 27.06.2025.
//

import Foundation

struct RegisterDeviceTokenResponse: Codable {
    let token: String
    let success: Bool
}
