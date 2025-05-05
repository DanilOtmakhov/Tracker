//
//  TabBarController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let trackersViewController: UINavigationController
    private let statisticsViewController: UINavigationController
    
    init(trackersViewController: UINavigationController, statisticsViewController: UINavigationController) {
        self.trackersViewController = trackersViewController
        self.statisticsViewController = statisticsViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTabBarAppearance()
    }
    
    private func setupViewController() {
        view.backgroundColor = .ypWhite

        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackers),
            selectedImage: nil
        )
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .stats),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.stackedLayoutAppearance.normal.iconColor = .ypGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ypGray]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.ypBlue]

        appearance.backgroundColor = .ypWhite
        appearance.shadowColor = .ypGray
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.layer.borderColor = UIColor.ypGray.cgColor
            tabBar.layer.borderWidth = 0.5
        }
    }

}
