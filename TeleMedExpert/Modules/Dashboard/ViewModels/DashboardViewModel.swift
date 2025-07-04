//
//  DashboardViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.07.2025.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    
    private let userClient: any UserClient
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userClient: any UserClient) {
        self.userClient = userClient
    }
    
    func getAllUsers() {
        userClient.getUsers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
            } receiveValue: { users in
                
            }
            .store(in: &cancellables)
    }
}
