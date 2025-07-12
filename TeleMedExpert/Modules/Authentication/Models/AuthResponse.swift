//
//  AuthResponse.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.07.2025.
//

import Foundation

struct AuthResponse: Codable {
    let userId: UUID
    let email: String
    let role: UserRole
    let token: TokenResponse
}
