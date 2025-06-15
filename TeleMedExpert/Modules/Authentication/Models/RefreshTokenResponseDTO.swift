//
//  RefreshTokenResponseDTO.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.05.2025.
//

import Foundation

struct RefreshTokenResponseDTO: Codable {
    let token: String
    let refreshToken: String
}
