//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.04.2025.
//

import UIKit

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

final class TrackersCoordinator: NavigationCoordinator {
    
    let navigationController = UINavigationController()
    private let dataManager = DataManager(CoreDataStack.shared.context)
    private var creationCoordinator: TrackerCreationCoordinator?
    
    func start() {
        let viewModel = TrackersViewModel(dataManager: dataManager)
        let viewController = TrackersViewController(viewModel: viewModel)
        
        viewController.onAddTrackerTapped = { [weak self] in
            self?.startTrackerCreation()
        }
        
        viewController.onFiltersButtonTapped = { [weak self, weak viewController] in
            guard let viewController else { return }
            self?.showFiltersSelectionViewController(presenter: viewController, presentingViewModel: viewModel)
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func startTrackerCreation() {
        let creationCoordinator = TrackerCreationCoordinator(dataManager, presentingViewController: navigationController)
        self.creationCoordinator = creationCoordinator
        
        creationCoordinator.start()
    }
    
    private func showFiltersSelectionViewController(presenter: UIViewController, presentingViewModel: TrackersViewModelProtocol) {
        let viewController = FilterSelectionViewController() // TODO: add selected
        
        viewController.onFilterSelected = { [weak viewController, weak presentingViewModel] filter in
            viewController?.dismiss(animated: true)
        }
        
        self.presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func presentInPageSheet(_ viewController: UIViewController, presenter: UIViewController) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet
        
        presenter.present(navController, animated: true)
    }
    
}


