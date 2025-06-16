//
//  RegisterRequestDTO.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 02.06.2025.
//

import Foundation

enum UserRole: String, Codable {
    case patient
    case doctor
}

struct RegisterRequestDTO: Codable {
    let email: String
    let password: String
    let role: UserRole
}
