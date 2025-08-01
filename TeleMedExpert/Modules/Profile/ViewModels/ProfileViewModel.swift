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
    
    var publisher: AnyPublisher<Event, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private var subject = PassthroughSubject<Event, Never>()

    private let userClient: UserClient
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userClient: UserClient) {
        self.userClient = userClient
    }
    
    func loadUserProfileInfo() {
        userClient.getUserProfile()
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        subject.send(.logout)
    }
}
