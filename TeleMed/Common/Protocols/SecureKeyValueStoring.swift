//
//  SecureKeyValueStoring.swift
//  TeleMed
//
//  Created by Ihor Ilin on 30.05.2025.
//

import Foundation

protocol SecureKeyValueStoring {
    func save<T: Codable>(_ value: T, for key: KeychainKey) throws
    func load<T: Codable>(_ type: T.Type, for key: KeychainKey) throws -> T
    func delete(for key: KeychainKey) throws
    func exist(key: KeychainKey) -> Bool
}
