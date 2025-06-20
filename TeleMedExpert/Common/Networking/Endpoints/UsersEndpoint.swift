//
//  UsersEndpoint.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.06.2025.
//

import Foundation

struct UsersEndpoint: Endpoint {
    var url: URL
    var method: String
    var headers: [String : String]
    var body: Data?
    
    static func getMe() -> UsersEndpoint {
        let path = "/users/me"
        
        return makeEndpoint(path: path, method: "GET", payload: nil)
    }
    
    private static func makeEndpoint(path: String, method: String, payload: [String: Any]?) -> UsersEndpoint {
        let baseURL = NetworkConfig.baseURL
        guard let fullURL = URL(string: baseURL + path) else {
            preconditionFailure("Invalid URL for path: \(path)")
        }

        var body: Data?
        if payload != nil {
            body = try? JSONSerialization.data(withJSONObject: payload as Any)
        }

        return UsersEndpoint(
            url: fullURL,
            method: method,
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }
}
