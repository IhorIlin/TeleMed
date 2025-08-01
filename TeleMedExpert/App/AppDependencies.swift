//
//  AppDependencies.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation
import PushKit

final class AppDependencies {
    let pushService: PushService
    let socketManager: SocketManager
    let sessionService: SessionService
    let networkClient: NetworkClient
    let tokenRefresher: TokenRefresher
    let authClient: AuthClient
    let protectedNetworkClient: ProtectedNetworkClient
    let apnsClient: APNSClient
    let keychainService: KeychainStore
    let callClient: CallClient
    let callKitManager: CallKitManager
    let userClient: UserClient
    let callEngine: CallEngine
    
    init() {
        networkClient = DefaultNetworkClient()
        authClient = DefaultAuthClient(networkClient: networkClient)
        keychainService = KeychainService()
        tokenRefresher = DefaultTokenRefresher(networkClient: networkClient, keychainService: keychainService)
        
        protectedNetworkClient = DefaultProtectedNetworkClient(networkClient: networkClient,
                                                               tokenRefresher: tokenRefresher,
                                                               keychainService: keychainService)
        
        apnsClient = DefaultAPNSClient(protectedNetworkClient: protectedNetworkClient)
        pushService = DefaultPushService(apnsClient: apnsClient, pushRegistry: PKPushRegistry(queue: .main))
        
        socketManager = DefaultSocketManager(configuration: SocketConfiguration.socketEndpoint(),
                                             tokenRefresher: tokenRefresher,
                                             keychainService: keychainService)
        
        sessionService = DefaultSessionService(keychainService: keychainService)
        
        callClient = DefaultCallClient(protectedNetworkClient: protectedNetworkClient)
        callKitManager = DefaultCallKitManager()
        userClient = DefaultUserClient(protectedNetworkClient: protectedNetworkClient)
        callEngine = DefaultCallEngine(callClient: callClient,
                                       socketManager: socketManager,
                                       pushService: pushService,
                                       callKitManager: callKitManager)
    }
}
