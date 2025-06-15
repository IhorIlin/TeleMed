//
//  UsersEndpoint.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 06.06.2025.
//

import Foundation

enum UsersEndpoint: Endpoint {
    case getMe
    
    var url: URL {
        let baseURL = NetworkConfig.baseURL

        let path: String
        switch self {
        case .getMe:
            path = "/users/me"
        }

        guard let url = URL(string: baseURL + path) else {
            preconditionFailure("Invalid URL for path: \(path)")
        }

        return url
    }
    
    var method: String {
        switch self {
        case .getMe:
            return "GET"
        }
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    var body: Data? {
        switch self {
        case .getMe:
            return nil
        }
    }
}
