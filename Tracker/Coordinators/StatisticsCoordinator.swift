//
//  StatisticsCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import UIKit

final class StatisticsCoordinator: NavigationCoordinator {
    
    let navigationController = UINavigationController()
    
    func start() {
        let viewModel = StatisticsViewModel()
        let viewController = StatisticsViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
}
