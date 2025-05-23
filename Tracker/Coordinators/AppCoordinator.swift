//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    
    // MARK: - Enums
    
    private enum UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    // MARK: - Private Properties

    private let window: UIWindow
    private var trackersCoordinator: TrackersCoordinator?
    private var statisticsCoordinator: StatisticsCoordinator?
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Start
    
    func start() {
        hasSeenOnboarding() ? showMainScreen() : showOnboarding()
    }
    
    // MARK: - Onboarding Flow
    
    private func showOnboarding() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onCompletion = { [weak self] in
            self?.markOnboardingAsSeen()
            self?.showMainScreen()
        }
        
        window.rootViewController = onboardingViewController
        window.makeKeyAndVisible()
    }
    
    private func hasSeenOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSeenOnboarding)
    }
    
    private func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
    }
    
    // MARK: - Main Screen Flow
    
    private func showMainScreen() {
        trackersCoordinator = TrackersCoordinator()
        statisticsCoordinator = StatisticsCoordinator()

        let tabBarController = createTabBarController()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        trackersCoordinator?.start()
        statisticsCoordinator?.start()
    }

    private func createTabBarController() -> UITabBarController {
        guard let trackersNavigationController = trackersCoordinator?.navigationController,
              let statisticsNavigationController = statisticsCoordinator?.navigationController else {
            fatalError("Dependencies not initialized")
        }

        return TabBarController(
            trackersViewController: trackersNavigationController,
            statisticsViewController: statisticsNavigationController
        )
    }
    
}


