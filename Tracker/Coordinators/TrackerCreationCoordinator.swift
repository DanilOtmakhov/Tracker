//
//  TrackerCreationCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerCreationCoordinator: Coordinator {
    
    private let trackerStore: MockTrackerCreationStoreProtocol
    private unowned let presentingViewController: UIViewController

    init(_ trackerStore: MockTrackerCreationStoreProtocol, presentingViewController: UIViewController) {
        self.trackerStore = trackerStore
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
                self?.showNewEventViewController(from: viewController)
            }
        }

        presentInPageSheet(viewController)
    }

    private func showNewHabitViewController(from presentingViewController: UIViewController?) {
        let viewModel = HabitFormViewModel(trackerStore: trackerStore)
        let viewController = HabitFormViewController(viewModel: viewModel)

        viewController.onScheduleCellTapped = { [weak self, weak viewController] in
            self?.showScheduleViewController(from: viewController, with: viewModel)
        }
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }

        presentInPageSheet(viewController, from: presentingViewController)
    }

    private func showNewEventViewController(from presentingViewController: UIViewController?) {
        let viewModel = EventFormViewModel(trackerStore: trackerStore)
        let viewController = EventFormViewController(viewModel: viewModel)
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }

        presentInPageSheet(viewController, from: presentingViewController)
    }

    private func showScheduleViewController(from presentingViewController: UIViewController?, with viewModel: HabitFormViewModelProtocol) {
        let viewController = ScheduleViewController()
        viewController.selectedDays = Set(viewModel.selectedDays)

        viewController.onDaysSelected = { days in
            viewModel.didSelectDays(days)
            presentingViewController?.dismiss(animated: true)
        }

        presentInPageSheet(viewController, from: presentingViewController)
    }
    
    private func finishCreationFlow() {
        presentingViewController.dismiss(animated: true)
    }

    private func presentInPageSheet(_ viewController: UIViewController, from: UIViewController? = nil) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet

        let presenter = from ?? presentingViewController
        presenter.present(navController, animated: true)
    }
}
