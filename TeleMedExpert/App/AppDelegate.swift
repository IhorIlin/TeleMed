//
//  AppDelegate.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 10.05.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var dependencies: AppDependencies!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dependencies = AppDependencies()
 
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Device token : \(deviceToken.hexString)")
        
        dependencies.pushService.registerRegularToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        dependencies.pushService.handleRemoteNotification(userInfo)
    }
}

