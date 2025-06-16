//
//  AuthEndpoint.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

struct AuthEndpoint: Endpoint {
    var url: URL
    var method: String
    var headers: [String : String]
    var body: Data?

    static func login(email: String, password: String) -> AuthEndpoint {
        let path = "/auth/login"
        return AuthEndpoint.makeEndpoint(path: path, payload: ["email": email, "password": password])
    }

    static func signUp(email: String, password: String, role: String) -> AuthEndpoint {
        let path = "/auth/register"
        return AuthEndpoint.makeEndpoint(path: path, payload: ["email": email, "password": password, "role": role])
    }

    static func forgotPassword(email: String) -> AuthEndpoint {
        let path = "/auth/forgot-password"
        return AuthEndpoint.makeEndpoint(path: path, payload: ["email": email])
    }

    static func refreshToken(refreshToken: String) -> AuthEndpoint {
        let path = "/auth/refresh"
        return AuthEndpoint.makeEndpoint(path: path, payload: ["refreshToken": refreshToken])
    }

    private static func makeEndpoint(path: String, payload: [String: Any]) -> AuthEndpoint {
        let baseURL = NetworkConfig.baseURL
        guard let fullURL = URL(string: baseURL + path) else {
            preconditionFailure("Invalid URL for path: \(path)")
        }

        let body = try? JSONSerialization.data(withJSONObject: payload)

        return AuthEndpoint(
            url: fullURL,
            method: "POST",
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }
}
