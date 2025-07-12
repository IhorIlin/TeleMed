//
//  CurrentUser.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 10.07.2025.
//

import Foundation

final class CurrentUser: Codable {
    var id: UUID
    var email: String
    var role: UserRole
    var firstName: String
    var lastName: String
    var avatarUrl: String?
    var address: String?
    var phoneNumber: String?
    var createdAt: String
    
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
