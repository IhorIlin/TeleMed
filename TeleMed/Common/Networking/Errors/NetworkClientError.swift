//
//  NetworkClientError.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

// MARK: - Error Handling

enum NetworkClientError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case noData
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .requestFailed(let error):
            return "The request failed with error: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code, _):
            return "Server returned error with status code \(code)."
        case .noData:
            return "No data was returned from the server."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
