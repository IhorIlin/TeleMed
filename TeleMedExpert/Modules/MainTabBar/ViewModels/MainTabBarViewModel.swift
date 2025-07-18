//
//  MainTabBarViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 26.06.2025.
//

import Combine
import Foundation

final class MainTabBarViewModel: ObservableObject {
    enum Event {
        case handleIncomingCall(StartCallRequestDTO)
    }
    
    private let pushService: PushService
    private let socketManager: SocketManager
    private let callKitManager: CallKitManager
    
    var eventPublisher: AnyPublisher<StartCallRequestDTO, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private var subject = PassthroughSubject<StartCallRequestDTO, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(pushService: PushService, socketManager: SocketManager, callKitManager: CallKitManager) {
        self.pushService = pushService
        self.socketManager = socketManager
        self.callKitManager = callKitManager
        
        bindPushNotifications()
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

// MARK: - VoIPNotification handling -
extension MainTabBarViewModel {
    private func bindPushNotifications() {
        pushService.pushPublisher
            .sink { [weak self] notification in
                self?.callKitManager.reportIncomingCall(payload: notification)
            }
            .store(in: &cancellables)
    }
}
