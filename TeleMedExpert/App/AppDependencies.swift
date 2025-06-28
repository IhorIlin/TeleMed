//
//  AppDependencies.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation
import PushKit

final class AppDependencies {
    let pushService: any PushManaging
    
    init() {
        let networkClient = DefaultNetworkClient()
        let keychainService = KeychainService()
        let tokenRefresher = DefaultTokenRefresher(networkClient: networkClient, keychainService: keychainService)
        let protectedNetworkClient = DefaultProtectedNetworkClient(networkClient: networkClient, tokenRefresher: tokenRefresher, keychainService: keychainService)
        let apnsClient = DefaultAPNSClient(protectedNetworkClient: protectedNetworkClient)
        pushService = PushService(apnsClient: apnsClient, pushRegistry: PKPushRegistry(queue: .main))
    }
}
