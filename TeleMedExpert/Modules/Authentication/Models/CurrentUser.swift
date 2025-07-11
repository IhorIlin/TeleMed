//
//  CurrentUser.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 10.07.2025.
//

import Foundation

final class CurrentUser: Codable {
    let id: UUID
    let email: String
    let role: UserRole
    let firstName: String
    let lastName: String
    let avatarUrl: String?
    let address: String?
    let phoneNumber: String?
    let createdAt: String
    
    init(id: UUID,
         email: String,
         role: UserRole,
         firstName: String,
         lastName: String,
         avatarUrl: String?,
         address: String?,
         phoneNumber: String?,
         createdAt: String) {
        
        self.id = id
        self.email = email
        self.role = role
        self.firstName = firstName
        self.lastName = lastName
        self.avatarUrl = avatarUrl
        self.address = address
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
    }
}
