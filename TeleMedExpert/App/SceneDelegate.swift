//
//  SceneDelegate.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 10.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        
        guard let dependencies = (UIApplication.shared.delegate as? AppDelegate)?.dependencies else { return }
        
        appCoordinator = AppCoordinator(window: window, dependencies: dependencies)
        
        appCoordinator?.start()
    }
}
