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
        case handleIncomingCall
    }
    
    private let callEngine: CallEngine
    private let pushService: PushService
    private let socketManager: SocketManager
    
    var eventPublisher: AnyPublisher<Event, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private var subject = PassthroughSubject<Event, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(callEngine: CallEngine, pushService: PushService, socketManager: SocketManager) {
        self.callEngine = callEngine
        self.pushService = pushService
        self.socketManager = socketManager
        
        bindEngine()
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
    
    private func bindEngine() {
        callEngine.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .incomingCallInApp, .incomingCall:
                    self?.subject.send(.handleIncomingCall)
                }
            }
            .store(in: &cancellables)
    }
}
