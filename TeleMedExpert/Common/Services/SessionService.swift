//
//  SessionService.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 20.06.2025.
//

import Foundation
import Combine

final class SessionService: SessionMonitor {
    private let keychainService: KeychainStore
    private let storage: UserDefaults
    
    @Published private(set) var currentUser: CurrentUser
    
    var currentUserPublisher: AnyPublisher<CurrentUser, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    
    var isLoggedIn: Bool {
        do {
            let tokens = try keychainService.loadAuthTokens()
            
            return !tokens.authToken.isEmpty && !tokens.refreshToken.isEmpty
        } catch {
            return false
        }
    }
    
    init(keychainService: KeychainStore, storage: UserDefaults = .standard) {
        self.keychainService = keychainService
        self.storage = storage
        self.currentUser = CurrentUser(id: UUID(),
                                       email: "",
                                       role: .patient,
                                       firstName: "",
                                       lastName: "",
                                       avatarUrl: "",
                                       address: "",
                                       phoneNumber: "",
                                       createdAt: "")
    }
    
    func setCurrentUser(_ user: CurrentUser) {
        self.currentUser = user
        
        do {
            let data = try JSONEncoder().encode(user)
            storage.set(data, forKey: "CurrentUser")
        } catch {
            print("❌ Failed to save user locally: \(error)")
        }
    }
    
    private func loadUserFromDisk() {
        guard let data = storage.data(forKey: "CurrentUser") else { return }
        
        do {
            let user = try JSONDecoder().decode(CurrentUser.self, from: data)
            self.currentUser = user
        } catch {
            print("❌ Failed to load user from disk: \(error)")
        }
    }
    
    func logout() {
        do {
            try keychainService.clearAuthTokens()
            storage.removeObject(forKey: "CurrentUser")
        } catch {
            // TODO: Handle error
        }
    }
}
