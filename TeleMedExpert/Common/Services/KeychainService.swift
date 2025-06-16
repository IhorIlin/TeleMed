//
//  KeychainService.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.05.2025.
//

import Foundation
import Security

typealias KeychainStore = SecureKeyValueStoring & TokenStoring

enum KeychainKey: String, CaseIterable {
    case authToken
    case refreshToken
}

enum KeychainError: Error {
    case decodingFailed
    case encodingFailed
    case itemNotFound
    case duplicateItem
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    
    var localizedDescription: String {
        switch self {
        case .encodingFailed:
            return "Failed to encode item for keychain storage"
        case .decodingFailed:
            return "Failed to decode item from keychain"
        case .itemNotFound:
            return "Item not found in keychain"
        case .duplicateItem:
            return "Item already exists in keychain"
        case .unexpectedPasswordData:
            return "Unexpected password data format"
        case .unhandledError(let status):
            return "Keychain error: \(status)"
        }
    }
}

final class KeychainService: SecureKeyValueStoring {
    private let serviceName = Bundle.main.bundleIdentifier ?? "KeychainService"
    
    func save<T>(_ value: T, for key: KeychainKey) throws where T: Decodable, T: Encodable {
        let data = try encodeValue(value)
        
        var query = baseQuery(for: key)
        query[kSecValueData as String] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            return
        case errSecDuplicateItem:
            try update(data: data, for: key)
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func load<T>(_ type: T.Type, for key: KeychainKey) throws -> T where T: Decodable, T: Encodable {
        var query = baseQuery(for: key)
        
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainError.unexpectedPasswordData
            }
            
            return try decodeValue(data, as: type)
        case errSecItemNotFound:
            throw KeychainError.itemNotFound
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func delete(for key: KeychainKey) throws {
        let query = baseQuery(for: key)
        
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess, errSecItemNotFound:
            return
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func exist(key: KeychainKey) -> Bool {
        var query = baseQuery(for: key)
        
        query[kSecReturnData as String] = false
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
}

extension KeychainService: TokenStoring {
    func saveAuthTokens(authToken: String, refreshToken: String) throws {
        try saveString(authToken, for: .authToken)
        try saveString(refreshToken, for: .refreshToken)
    }
    
    func loadAuthTokens() throws -> (authToken: String, refreshToken: String) {
        let authToken = try loadString(for: .authToken)
        let refreshToken = try loadString(for: .refreshToken)
        
        return (authToken, refreshToken)
    }
    
    func clearAuthTokens() throws {
        try delete(for: .authToken)
        try delete(for: .refreshToken)
    }
}

// MARK: - Convenience methods -
extension KeychainService {
    func saveString(_ string: String, for key: KeychainKey) throws {
        try save(string, for: key)
    }
    
    func loadString(for key: KeychainKey) throws -> String {
        return try load(String.self, for: key)
    }
    
    func deleteAll() throws {
        for key in KeychainKey.allCases {
            try delete(for: key)
        }
    }
}

// MARK: - Helpers -
extension KeychainService {
    private func update(data: Data, for key: KeychainKey) throws {
        let query = baseQuery(for: key)
        
        let updatedFields = [kSecValueData as String: data]
        
        let status = SecItemUpdate(query as CFDictionary, updatedFields as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private func baseQuery(for key: KeychainKey) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue
        ]
    }
    
    private func encodeValue<T: Codable>(_ value: T) throws -> Data {
        if let string = value as? String {
            return Data(string.utf8)
        } else {
            do {
                return try JSONEncoder().encode(value)
            } catch {
                throw KeychainError.encodingFailed
            }
        }
    }
    
    private func decodeValue<T: Codable>(_ data: Data, as type: T.Type) throws -> T {
        if T.self == String.self, let string = String(data: data, encoding: .utf8) as? T {
            return string
        } else {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw KeychainError.decodingFailed
            }
        }
    }
}
