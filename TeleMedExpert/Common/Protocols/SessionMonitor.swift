//
//  SessionMonitor.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 20.06.2025.
//

import Foundation

protocol SessionMonitor {
    var isLogedIn: Bool { get }
    func logout()
}
