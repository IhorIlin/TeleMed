//
//  AppointmentsCoordinator.swift
//  TeleMed
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit

final class AppointmentsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let appointmentsController = AppointmentsViewController()
        
        navigationController.pushViewController(appointmentsController, animated: false)
        
        navigationController.tabBarItem = UITabBarItem.init(title: "Appointments", image: UIImage(systemName: "calendar"), tag: 1)
    }
}
