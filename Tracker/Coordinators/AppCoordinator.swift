//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

protocol Coordinator {
    
//    var navigationController: UINavigationController { get }
    func start()
    
}

final class AppCoordinator: Coordinator {
    
    private enum UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    let window: UIWindow
    
    private var trackersCoordinator: TrackersCoordinator?
    private var statisticsViewController: StatisticsViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSeenOnboarding)
        
        if hasSeenOnboarding {
            showMainScreen()
        } else {
            showOnboarding()
        }
    }
    
    private func showMainScreen() {
        let trackersCoordinator = TrackersCoordinator()
        self.trackersCoordinator = trackersCoordinator
        
        let statisticsViewController = StatisticsViewController()
        self.statisticsViewController = statisticsViewController
        
        let tabBarController = TabBarController(trackersViewController: trackersCoordinator.navigationController, statisticsViewController: UINavigationController(rootViewController: statisticsViewController))
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        trackersCoordinator.start()
    }
    
    private func showOnboarding() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onCompletion = { [weak self] in
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
            self?.showMainScreen()
        }
        
        window.rootViewController = onboardingViewController
        window.makeKeyAndVisible()
    }
    
}


