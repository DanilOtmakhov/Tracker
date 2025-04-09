//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

protocol Coordinator {
    
//    var navigationController: UINavigationController { get }
    func start()
    
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

final class TrackersCoordinator: NavigationCoordinator {
    
    let navigationController = UINavigationController()
    private let trackerStore = TrackerStore()
    private var creationCoordinator: TrackerCreationCoordinator?
    
    func start() {
        let viewModel = TrackersViewModel(store: trackerStore)
        let viewController = TrackersViewController(viewModel: viewModel)
        
        viewController.onAddTrackerTapped = { [weak self] in
            self?.startTrackerCreation()
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func startTrackerCreation() {
        let creationCoordinator = TrackerCreationCoordinator(presentingViewController: navigationController)
        self.creationCoordinator = creationCoordinator
        
        creationCoordinator.start()
//        navigationController.present(
//            creationCoordinator.navigationController,
//            animated: true
//        )
    }
}


