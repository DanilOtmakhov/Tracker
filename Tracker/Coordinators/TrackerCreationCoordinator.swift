//
//  TrackerCreationCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerCreationCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        setupNavigationController()
    }
    
    func start() {
        showTrackerTypeSelection()
    }
    
    private func setupNavigationController() {
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.navigationBar.prefersLargeTitles = false
    }
    
    private func showTrackerTypeSelection() {
        let viewController = TrackerTypeSelectionViewController()
        
        viewController.onTrackerTypeSelected = { [weak self] type in
            switch type {
            case .habit:
                self?.showNewHabitViewController()
            case .event:
                self?.showNewEventViewController()
            }
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showNewHabitViewController() {
        let viewModel = TrackerFormViewModel()
        let viewController = TrackerFormViewController(viewModel: viewModel)
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        navigationController.present(navController, animated: true)
    }
    
    private func showNewEventViewController() {

    }
}
