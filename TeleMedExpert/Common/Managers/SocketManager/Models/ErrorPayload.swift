//
//  ErrorPayload.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

struct ErrorPayload: Codable {
    let code: SocketErrorCode
    let message: String
}
