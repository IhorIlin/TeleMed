//
//  SessionMonitor.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 20.06.2025.
//

import Foundation

import Combine
import Foundation

protocol SessionMonitor: AnyObject {
    var currentUser: CurrentUser? { get }
    var currentUserPublisher: AnyPublisher<CurrentUser?, Never> { get }
    var isLoggedIn: Bool { get }
    
    func setCurrentUser(_ user: CurrentUser)
    func logout()
}
