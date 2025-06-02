//
//  LoginResponseDTO.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

struct LoginResponseDTO: Codable {
    let token: String
    let refreshToken: String
}
