//
//  Storyboard.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

enum Storyboard: String {
    case auth = "Auth"
    case mainTabBar = "MainTabBar"
    case profile = "Profile"
    case dashboard = "Dashboard"
    case appointments = "Appointments"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
}
