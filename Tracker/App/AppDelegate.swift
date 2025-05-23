//
//  AppDelegate.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit
import YandexMobileMetrica

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: Coordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "0a10a2a8-b7c1-4271-aba7-e790d7018910") else { return true }
        YMMYandexMetrica.activate(with: configuration)
        
        configureNavigationBarAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        return true
    }
    
    private func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite
        appearance.shadowColor = nil
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.ypBlack
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.ypBlack
        ]
        
        navigationBarAppearance.standardAppearance = appearance
        navigationBarAppearance.scrollEdgeAppearance = appearance
        navigationBarAppearance.compactAppearance = appearance
    }

}

