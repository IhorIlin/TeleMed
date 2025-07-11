//
//  MainTabBarViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 26.06.2025.
//

import Combine
import Foundation

final class MainTabBarViewModel: ObservableObject {
    private let pushService: PushManaging
    private let socketManager: SocketManaging
    
    private var cancellables = Set<AnyCancellable>()
    
    init(pushService: PushManaging, socketManager: SocketManaging) {
        self.pushService = pushService
        self.socketManager = socketManager
    }
    
    func registerPushNotifications() {
        pushService.requestNotificationPermission()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Push permission flow finished.")
                case .failure(let error):
                    print("❌ Failed to request push permission: \(error)")
                    switch error {
                    case .denied:
                        // Show ui with explanation how to enable push notification in settings
                        break
                    default:
                        break
                    }
                }
            } receiveValue: {
                print("✅ Push permission granted.")
            }
            .store(in: &cancellables)
    }
    
    func connectWS() async {
        do {
            try await socketManager.connect()
            print("ws connection established sucessfully")
        } catch {
            print("\(#function) error: \(error.localizedDescription)")
        }
    }
}
