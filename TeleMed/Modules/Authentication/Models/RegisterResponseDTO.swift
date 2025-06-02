//
//  RegisterResponseDTO.swift
//  TeleMed
//
//  Created by Ihor Ilin on 02.06.2025.
//

import Foundation

struct RegisterResponseDTO: Codable {
    let token: String
    let refreshToken: String
}
