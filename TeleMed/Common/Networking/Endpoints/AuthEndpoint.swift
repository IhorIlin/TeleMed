//
//  AuthEndpoint.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(email: String, password: String)
    case signUp(email: String, password: String, role: String)
    case forgotPassword(email: String)
    case refreshToken(refreshToken: String)
    
    var url: URL {
        let baseURL = NetworkConfig.baseURL

        let path: String
        switch self {
        case .login:
            path = "/auth/login"
        case .signUp:
            path = "/auth/register"
        case .forgotPassword:
            path = "/auth/forgot-password"
        case .refreshToken:
            path = "/auth/refresh"
        }

        guard let url = URL(string: baseURL + path) else {
            preconditionFailure("Invalid URL for path: \(path)")
        }

        return url
    }
    
    var method: String {
        return "POST"
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    var body: Data? {
        switch self {
        case .login(let email, let password):
            let payload = ["email": email, "password": password]
            
            return try? JSONSerialization.data(withJSONObject: payload)
        case .signUp(let email, let password, let role):
            let payload = ["email": email, "password": password, "role": role]
            
            return try? JSONSerialization.data(withJSONObject: payload)
        case .forgotPassword(let email):
            let payload = ["email": email]
            
            return try? JSONSerialization.data(withJSONObject: payload)
        case .refreshToken(let refreshToken):
            let payload = ["refreshToken": refreshToken]
            
            return try? JSONSerialization.data(withJSONObject: payload)
        }
    }
}
