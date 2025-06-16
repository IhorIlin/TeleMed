//
//  UserProfileResponseDTO.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 12.06.2025.
//

import Foundation

struct UserProfileResponseDTO: Codable {
    let id: UUID
    let email: String
    let role: UserRole
    let firstName: String
    let lastName: String
    let avatarUrl: String?
    let address: String?
    let phoneNumber: String?
    let createdAt: String
}
