//
//  MainTabBarViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 02.06.2025.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    private let viewModel: MainTabBarViewModel
    
    var handleIncomingCall: ((StartCallRequestDTO) -> Void)?
    
    init(viewModel: MainTabBarViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.registerPushNotifications()
        
        Task {
            await connectWebSocket()
        }
    }
    
    deinit {
        print("MainTabBarViewController deinited")
    }
}

extension MainTabBarViewController {
    private func connectWebSocket() async {
        await viewModel.connectWS()
    }
    
    private func bindViewModel() {
        
    }
}
