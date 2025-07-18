//
//  DefaultPushService.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation
import Combine
import PushKit
import UserNotifications
import UIKit
import CallKit

final class DefaultPushService: NSObject, PushService {
    private let apnsClient: any APNSClient
    private var pushRegistry: any PushRegistryManaging
    private let pushSubject = PassthroughSubject<VoIPNotificationPayload, Never>()
    
    var pushPublisher: AnyPublisher<VoIPNotificationPayload, Never> {
        pushSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apnsClient: any APNSClient, pushRegistry: any PushRegistryManaging) {
        self.apnsClient = apnsClient
        self.pushRegistry = pushRegistry
    }
    
    func requestNotificationPermission() -> AnyPublisher<Void, PushPermissionError> {
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        
        return Future { promise in
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if let error = error {
                            promise(.failure(.systemError(error)))
                        } else if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                            promise(.success(()))
                        } else {
                            promise(.failure(.denied))
                        }
                    }
                case .denied:
                    promise(.failure(.denied))
                default:
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func registerRegularToken(_ token: Data) {
        let model = RegisterDeviceTokenDTO(token: token.hexString, isVoIP: false)
        
        apnsClient.registerAPNsDeviceToken(with: model)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Failed to register regular token: \(error)")
                }
            } receiveValue: { _ in
                print("Regular apns token successfully registered")
            }.store(in: &cancellables)

    }
    
    func registerVoIPToken(_ token: Data) {
        let model = RegisterDeviceTokenDTO(token: token.hexString, isVoIP: true)
        
        apnsClient.registerVoIPDeviceToken(with: model)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Failed to register VoIP token: \(error)")
                }
            } receiveValue: { response in
                // TODO: handle success token registration
                print("VoIP apns token successfully registered")
            }.store(in: &cancellables)
    }
    
    func handleVoIPPayload(_ payload: PKPushPayload) {
        guard let rootDict = payload.dictionaryPayload as? [String: Any],
              let payloadDict = rootDict["payload"] as? [String: Any] else {
            print("❌ Invalid payload structure")
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: payloadDict, options: [])
            let model = try JSONDecoder().decode(VoIPNotificationPayload.self, from: data)
            
            pushSubject.send(model)
            print("✅ VoIP payload converted: \(model)")
            
        } catch {
            print("❌ Failed to decode VoIP payload: \(error)")
        }
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        print("Regular push info: \(userInfo)")
    }
}

// MARK: - PKPushRegistryDelegate -
extension DefaultPushService: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        registerVoIPToken(pushCredentials.token)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        handleVoIPPayload(payload)
        completion()
    }
}
