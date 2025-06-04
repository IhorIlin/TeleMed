//
//  DashboardViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "Dashboard"
    }
}
