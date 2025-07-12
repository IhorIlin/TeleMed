//
//  TokenStoring.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 02.06.2025.
//

import Foundation

protocol TokenStoring {
    func saveAuthTokens(authToken: String, refreshToken: String) throws
    func loadAuthTokens() throws -> (authToken: String, refreshToken: String)
    func clearAuthTokens() throws
    
    func saveString(_ string: String, for key: KeychainKey) throws
    func loadString(for key: KeychainKey) throws -> String
    func deleteAll() throws
}
