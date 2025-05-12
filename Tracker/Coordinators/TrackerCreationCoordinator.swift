//
//  TrackerCreationCoordinator.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerCreationCoordinator: Coordinator {
    
    private let dataManager: DataManagerProtocol
    private unowned let presentingViewController: UIViewController
    
    init(_ dataManager: DataManagerProtocol, presentingViewController: UIViewController) {
        self.dataManager = dataManager
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
        let viewModel = HabitFormViewModel(dataManager: dataManager)
        let viewController = HabitFormViewController(viewModel: viewModel)
        
        viewController.onCategoryCellTapped = { [weak self] in
            self?.showCategoriesViewController(from: viewController, with: viewModel)
        }
        
        viewController.onScheduleCellTapped = { [weak self] in
            self?.showScheduleViewController(from: viewController, with: viewModel)
        }
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }
        
        presentInPageSheet(viewController, from: presentingViewController)
    }
    
    private func showNewEventViewController(from presentingViewController: UIViewController?) {
        let viewModel = EventFormViewModel(dataManager: dataManager)
        let viewController = EventFormViewController(viewModel: viewModel)
        
        viewController.onCategoryCellTapped = { [weak self] in
            self?.showCategoriesViewController(from: viewController, with: viewModel)
        }
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }
        
        presentInPageSheet(viewController, from: presentingViewController)
    }
    
    private func showCategoriesViewController(from presentingViewController: UIViewController?, with presentingViewModel: TrackerFormViewModelProtocol) {
        let viewModel = CategoriesViewModel(dataManager.categoryProvider)
        viewModel.selectedCategory = presentingViewModel.selectedCategory
        let viewController = CategoriesViewController(viewModel: viewModel)
        
        viewModel.onCategorySelected = { [weak viewController, weak presentingViewModel] category in
            presentingViewModel?.didSelectCategory(category)
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        presentInPageSheet(viewController, from: presentingViewController)
    }
    
    private func showScheduleViewController(from presentingViewController: UIViewController?, with presentingViewModel: HabitFormViewModelProtocol) {
        let viewController = ScheduleViewController()
        viewController.selectedDays = Set(presentingViewModel.selectedDays)
        
        viewController.onDaysSelected = { [weak viewController, weak presentingViewModel] days in
            presentingViewModel?.didSelectDays(days)
            viewController?.dismiss(animated: true)
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
