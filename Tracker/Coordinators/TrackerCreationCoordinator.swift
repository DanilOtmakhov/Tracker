//
//  TrackerCreationCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

//import UIKit
//
//final class TrackerCreationCoordinator: Coordinator {
//    
//    let navigationController: UINavigationController
//    
//    init(navigationController: UINavigationController = UINavigationController()) {
//        self.navigationController = navigationController
//        setupNavigationController()
//    }
//    
//    func start() {
//        showTrackerTypeSelection()
//    }
//    
//    private func setupNavigationController() {
//        navigationController.modalPresentationStyle = .pageSheet
//        navigationController.navigationBar.prefersLargeTitles = false
//    }
//    
//    private func showTrackerTypeSelection() {
//        let viewController = TrackerTypeSelectionViewController()
//        
//        viewController.onTrackerTypeSelected = { [weak self] type in
//            switch type {
//            case .habit:
//                self?.showNewHabitViewController()
//            case .event:
//                self?.showNewEventViewController()
//            }
//        }
//        
//        navigationController.setViewControllers([viewController], animated: false)
//    }
//    
//    private func showNewHabitViewController() {
//        let viewModel = TrackerFormViewModel()
//        let viewController = TrackerFormViewController(viewModel: viewModel)
//        
//        viewController.onScheduleCellTapped = { [weak self] in
//            self?.showScheduleViewController(with: viewModel)
//        }
//        
//        let navController = UINavigationController(rootViewController: viewController)
//        navController.modalPresentationStyle = .pageSheet
//        navigationController.present(navController, animated: true)
//    }
//    
//    private func showNewEventViewController() {
//
//    }
//    
//    private func showScheduleViewController(with viewModel: TrackerFormViewModelProtocol) {
//        let viewController = ScheduleViewController()
//        
//        viewController.selectedDays = Set(viewModel.selectedDays)
//        
//        viewController.onDaysSelected = { [weak self] days in
//            viewModel.updateSelectedDays(days)
//            self?.navigationController.dismiss(animated: true)
//            
//        }
//        
//        let navController = UINavigationController(rootViewController: viewController)
//        navController.modalPresentationStyle = .pageSheet
//        navigationController.present(navController, animated: true)
//    }
//    
//}

import UIKit

final class TrackerCreationCoordinator: Coordinator {
    
    private unowned let presentingViewController: UIViewController

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    func start() {
        showTrackerTypeSelection()
    }

    private func showTrackerTypeSelection() {
        let viewController = TrackerTypeSelectionViewController()
        
        viewController.onTrackerTypeSelected = { [weak self, weak viewController] type in
            switch type {
            case .habit:
                self?.showNewHabitViewController(from: viewController)
            case .event:
                self?.showNewEventViewController()
            }
        }

        presentInPageSheet(viewController)
    }

    private func showNewHabitViewController(from presentingViewController: UIViewController?) {
        let viewModel = TrackerFormViewModel()
        let viewController = TrackerFormViewController(viewModel: viewModel)

        viewController.onScheduleCellTapped = { [weak self, weak viewController] in
            self?.showScheduleViewController(from: viewController, with: viewModel)
        }

        presentInPageSheet(viewController, from: presentingViewController)
    }

    private func showNewEventViewController() {
        
    }

    private func showScheduleViewController(from presentingViewController: UIViewController?, with viewModel: TrackerFormViewModelProtocol) {
        let viewController = ScheduleViewController()
        viewController.selectedDays = Set(viewModel.selectedDays)

        viewController.onDaysSelected = { days in
            viewModel.updateSelectedDays(days)
            presentingViewController?.dismiss(animated: true)
        }

        presentInPageSheet(viewController, from: presentingViewController)
    }

    private func presentInPageSheet(_ viewController: UIViewController, from: UIViewController? = nil) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet

        let presenter = from ?? presentingViewController
        presenter.present(navController, animated: true)
    }
}
