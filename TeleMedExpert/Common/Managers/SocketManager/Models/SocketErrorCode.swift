//
//  SocketErrorCode.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.07.2025.
//

import Foundation

enum SocketErrorCode: String, Codable {
    case unauthorized
    case userNotFound
    case invalidPayload
    case callAlreadyExists
    case serverError
    case unknown
}
