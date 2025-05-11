//
//  SceneDelegate.swift
//  TeleMed
//
//  Created by Ihor Ilin on 10.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        appCoordinator = AppCoordinator()
        appCoordinator?.start()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator?.tabBarController
        window?.makeKeyAndVisible()
    }
}

