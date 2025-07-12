//
//  DashboardCoordinatorDelegate.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Foundation

protocol DashboardCoordinatorDelegate: AnyObject {
    // for test local call - remove in production
    func startLocalCall(userId: UUID)
}
