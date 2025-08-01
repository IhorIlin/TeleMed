//
//  DashboardViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.07.2025.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    enum Event {
        case usersLoaded([DashboardUserModel])
        case logout
    }
    
    private let userClient: any UserClient
    
    var publisher: AnyPublisher<Event, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let subject = PassthroughSubject<Event, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userClient: any UserClient) {
        self.userClient = userClient
    }
    
    func getAllUsers() {
        userClient.getUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    switch error {
                    case .unauthorized:
                        self?.subject.send(.logout)
                    default:
                        break
                    }
                case .finished:
                    break
                }
            } receiveValue: { users in
                let userModels = users.map { DashboardUserModel(userId: $0.id, email: $0.email, userRole: $0.role) }
                
                self.subject.send(.usersLoaded(userModels))
            }
            .store(in: &cancellables)
    }
}
