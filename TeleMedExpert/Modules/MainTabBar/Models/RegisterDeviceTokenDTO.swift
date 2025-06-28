//
//  RegisterDeviceTokenDTO.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 26.06.2025.
//

import Foundation

struct RegisterDeviceTokenDTO: Codable {
    let token: String
    let isVoIP: Bool
}
