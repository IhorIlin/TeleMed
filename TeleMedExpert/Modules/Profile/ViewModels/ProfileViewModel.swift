//
//  ProfileViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 11.06.2025.
//

import Combine

final class ProfileViewModel: ObservableObject {
    enum Event {
        case logout
        case showEditProfile
    }
    
    private(set) var subject = PassthroughSubject<Event, Never>()
    
    func loadUserProfileInfo() {
        
    }
}
