//
//  StartCallRequestDTO.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 09.07.2025.
//

import Foundation

struct StartCallRequestDTO: Codable {
    let calleeId: UUID
    let callType: CallType
}
