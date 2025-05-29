//
//  NetworkConfig.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

enum NetworkConfig {
    static var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("❌ BASE_URL not set in Info.plist")
        }
        
        return baseURL
    }
}
