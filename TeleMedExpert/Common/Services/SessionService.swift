//
//  SessionService.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 20.06.2025.
//

import Foundation

final class SessionService: SessionMonitor {
    private let keychainService: KeychainStore
    
    var isLogedIn: Bool {
        do {
            let tokens = try keychainService.loadAuthTokens()
            
            return !tokens.authToken.isEmpty && !tokens.refreshToken.isEmpty
        } catch {
            return false
        }
    }
    
    init(keychainService: KeychainStore) {
        self.keychainService = keychainService
    }
    
    func logout() {
        do {
            try keychainService.clearAuthTokens()
        } catch {
            // TODO: Handle error
        }
    }
}
