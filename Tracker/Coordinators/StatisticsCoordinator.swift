//
//  StatisticsCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import UIKit

final class StatisticsCoordinator: NavigationCoordinator {
    
    let navigationController = UINavigationController()
    private let dataManager = DataManager(CoreDataStack.shared.context)
    
    func start() {
        let statisticsService = StatisticsService(store: StatisticStore(), recordStore: dataManager.recordProvider)
        let viewModel = StatisticsViewModel(statisticsService: statisticsService)
        let viewController = StatisticsViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
}
