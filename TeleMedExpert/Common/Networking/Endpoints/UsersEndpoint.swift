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
        
        return makeEndpoint(path: path, method: "GET", payload: [:])
    }
    
    private static func makeEndpoint(path: String, method: String, payload: [String: Any]) -> UsersEndpoint {
        let baseURL = NetworkConfig.baseURL
        guard let fullURL = URL(string: baseURL + path) else {
            preconditionFailure("Invalid URL for path: \(path)")
        }

        let body = try? JSONSerialization.data(withJSONObject: payload)

        return UsersEndpoint(
            url: fullURL,
            method: "POST",
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }
}
//enum UsersEndpoint: Endpoint {
//    case getMe
//    
//    var url: URL {
//        let baseURL = NetworkConfig.baseURL
//
//        let path: String
//        switch self {
//        case .getMe:
//            path = "/users/me"
//        }
//
//        guard let url = URL(string: baseURL + path) else {
//            preconditionFailure("Invalid URL for path: \(path)")
//        }
//
//        return url
//    }
//    
//    var method: String {
//        switch self {
//        case .getMe:
//            return "GET"
//        }
//    }
//    
//    var headers: [String : String] {
//        ["Content-Type": "application/json"]
//    }
//    
//    var body: Data? {
//        switch self {
//        case .getMe:
//            return nil
//        }
//    }
//}
