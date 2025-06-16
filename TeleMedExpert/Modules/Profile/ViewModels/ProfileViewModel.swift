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
    private var cancellables = Set<AnyCancellable>()
    private(set) var subject = PassthroughSubject<Event, Never>()
    
    private let userClient: UserClient
    
    init(userClient: UserClient) {
        self.userClient = userClient
    }
    
    func loadUserProfileInfo() {
        userClient.getUserProfile()
            .sink { completion in
                
            } receiveValue: { response in
                
            }
            .store(in: &cancellables)
    }
}
