//
//  DashboardCoordinatorDelegate.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Foundation

protocol DashboardCoordinatorDelegate: AnyObject {
    func startCall(userId: UUID)
    func logout()
}
