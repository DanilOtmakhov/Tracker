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
                self?.showHabitFormViewController(presenter: viewController)
            case .event:
                self?.showEventFormViewController(presenter: viewController)
            }
        }
        
        presentInPageSheet(viewController)
    }
    
    private func showHabitFormViewController(presenter: UIViewController?) {
        let viewModel = HabitFormViewModel(dataManager: dataManager)
        let viewController = HabitFormViewController(viewModel: viewModel)
        
        viewController.onCategoryCellTapped = { [weak self] in
            self?.showCategoriesViewController(presenter: viewController, with: viewModel)
        }
        
        viewController.onScheduleCellTapped = { [weak self] in
            self?.showScheduleViewController(presenter: viewController, with: viewModel)
        }
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }
        
        presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func showEventFormViewController(presenter: UIViewController?) {
        let viewModel = EventFormViewModel(dataManager: dataManager)
        let viewController = EventFormViewController(viewModel: viewModel)
        
        viewController.onCategoryCellTapped = { [weak self] in
            self?.showCategoriesViewController(presenter: viewController, with: viewModel)
        }
        
        viewController.onCreatedButtonTapped = { [weak self] in
            self?.finishCreationFlow()
        }
        
        presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func showCategoriesViewController(presenter: UIViewController?, with presentingViewModel: TrackerFormViewModelProtocol) {
        let viewModel = CategoriesViewModel(dataManager.categoryProvider)
        viewModel.selectedCategory = presentingViewModel.selectedCategory
        let viewController = CategoriesViewController(viewModel: viewModel)
        
        viewModel.onCategorySelected = { [weak viewController, weak presentingViewModel] category in
            presentingViewModel?.didSelectCategory(category)
            viewController?.dismiss(animated: true, completion: nil)
        }
        
        viewModel.onCategorySelectedForEditing = { [weak self, weak viewController] category in
            self?.showCategoryFormViewController(presenter: viewController, categoryToEdit: category)
        }
        
        viewController.onAddButtonTapped = { [weak self, weak viewController] in
            self?.showCategoryFormViewController(presenter: viewController)
        }
        
        presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func showScheduleViewController(presenter: UIViewController?, with presentingViewModel: HabitFormViewModelProtocol) {
        let viewController = ScheduleViewController()
        viewController.selectedDays = Set(presentingViewModel.selectedDays)
        
        viewController.onDaysSelected = { [weak viewController, weak presentingViewModel] days in
            presentingViewModel?.didSelectDays(days)
            viewController?.dismiss(animated: true)
        }
        
        presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func showCategoryFormViewController(presenter: UIViewController?, categoryToEdit: TrackerCategory? = nil) {
        let viewModel = CategoryFormViewModel(categoryProvider: dataManager.categoryProvider, categoryToEdit: categoryToEdit)
        let viewController = CategoryFormViewController(viewModel: viewModel)
        
        viewModel.onFormCompleted = { [weak viewController] in
            viewController?.dismiss(animated: true)
        }
        
        presentInPageSheet(viewController, presenter: presenter)
    }
    
    private func finishCreationFlow() {
        presentingViewController.dismiss(animated: true)
    }

    private func presentInPageSheet(_ viewController: UIViewController, presenter: UIViewController? = nil) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .pageSheet

        let presenter = presenter ?? presentingViewController
        presenter.present(navController, animated: true)
    }
}
