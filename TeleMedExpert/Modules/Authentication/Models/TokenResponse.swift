//
//  TokenResponse.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.07.2025.
//

import Foundation

struct TokenResponse: Codable {
    let token: String
    let refreshToken: String
}
