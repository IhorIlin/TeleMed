//
//  AppointmentsViewController.swift
//  TeleMed
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

class AppointmentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "Appointments"
    }
}
