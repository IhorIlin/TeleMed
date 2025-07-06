//
//  DashboardUserModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.07.2025.
//

import Foundation

struct DashboardUserModel: Codable {
    let userId: UUID
    let email: String
    let userRole: UserRole
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case email = "email"
        case userRole = "userRole"
    }
}
