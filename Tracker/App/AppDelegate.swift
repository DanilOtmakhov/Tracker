//
//  AppDelegate.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.ypBlack
        ]
        
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.ypBlack
        ]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        return true
    }

}

