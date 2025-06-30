//
//  DashboardViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var startCallCallback: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "Dashboard"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(startCall))
        
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func startCall() {
        startCallCallback?()
    }
    
    deinit {
        print("DashboardViewController deinited")
    }
}
