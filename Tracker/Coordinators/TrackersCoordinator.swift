//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController { get }
    func start()
    
}

final class TrackersCoordinator: Coordinator {
    
    let navigationController = UINavigationController()
    
    private let trackerStore = TrackerStore()
    
    func start() {
        let viewModel = TrackersViewModel(store: trackerStore)
        let viewController = TrackersViewController(viewModel: viewModel)
        
        viewController.onAddTrackerTapped = { [weak self] in
            self?.showTrackerTypeSelection()
        }
        
        navigationController.viewControllers = [viewController]
    }
    
    private func showTrackerTypeSelection() {
        let viewController = TrackerTypeSelectionViewController()
        
        viewController.onTrackerTypeSelected = { [weak self] type in
            switch type {
            case .habit:
                print("habit")
            case .event:
                print("event")
            }
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        
        navigationController.present(navController, animated: true)
    }
    
}
