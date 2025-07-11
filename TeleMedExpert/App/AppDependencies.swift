//
//  AppDependencies.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation
import PushKit

final class AppDependencies {
    let pushService: PushManaging
    let socketManager: SocketManaging
    let sessionService: SessionMonitor
    let networkClient: NetworkClient
    let tokenRefresher: TokenRefresher
    let authClient: AuthClient
    let protectedNetworkClient: ProtectedNetworkClient
    let apnsClient: APNSClient
    let keychainService: KeychainStore
    let callClient: CallClient
    
    init() {
        networkClient = DefaultNetworkClient()
        authClient = DefaultAuthClient(networkClient: networkClient)
        keychainService = KeychainService()
        tokenRefresher = DefaultTokenRefresher(networkClient: networkClient, keychainService: keychainService)
        
        protectedNetworkClient = DefaultProtectedNetworkClient(networkClient: networkClient,
                                                               tokenRefresher: tokenRefresher,
                                                               keychainService: keychainService)
        
        apnsClient = DefaultAPNSClient(protectedNetworkClient: protectedNetworkClient)
        pushService = PushService(apnsClient: apnsClient, pushRegistry: PKPushRegistry(queue: .main))
        
        socketManager = SocketManager(configuration: SocketConfiguration.socketEndpoint(),
                                      tokenRefresher: tokenRefresher,
                                      keychainService: keychainService)
        
        sessionService = SessionService(keychainService: keychainService)
        
        callClient = DefaultCallClient(protectedNetworkClient: protectedNetworkClient)
    }
}
