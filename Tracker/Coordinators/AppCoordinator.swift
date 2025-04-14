//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

final class AppCoordinator {

    let window: UIWindow
    
    private var trackersCoordinator: TrackersCoordinator?
    private var statisticsViewController: StatisticsViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let trackersCoordinator = TrackersCoordinator()
        self.trackersCoordinator = trackersCoordinator
        
        let statisticsViewController = StatisticsViewController()
        self.statisticsViewController = statisticsViewController
        
        let tabBarController = TabBarController(trackersViewController: trackersCoordinator.navigationController, statisticsViewController: UINavigationController(rootViewController: statisticsViewController))
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        trackersCoordinator.start()
    }
    
}


