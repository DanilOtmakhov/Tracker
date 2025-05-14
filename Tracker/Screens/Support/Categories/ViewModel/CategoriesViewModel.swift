//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.05.2025.
//

import Foundation

enum CategoriesViewModelState {
    case content(update: TrackerCategoryStoreUpdate)
    case empty(update: TrackerCategoryStoreUpdate)
    
    var update: TrackerCategoryStoreUpdate {
        switch self {
        case .content(let update), .empty(let update):
            return update
        }
    }
}

protocol CategoriesViewModelProtocol {
    var onStateChange: ((CategoriesViewModelState) -> Void)? { get set }
    var onCategorySelected: ((TrackerCategory) -> Void)? { get set }
    var onCategorySelectedForEditing: ((TrackerCategory) -> Void)? { get set }
    func numberOfRows(in section: Int) -> Int
    func categoryTitle(at indexPath: IndexPath) -> String?
    func didSelectCategory(at indexPath: IndexPath)
    func isCategorySelected(at indexPath: IndexPath) -> Bool
    func reloadState()
    func editCategory(at indexPath: IndexPath)
    func deleteCategory(at indexPath: IndexPath)
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((CategoriesViewModelState) -> Void)?
    var onCategorySelected: ((TrackerCategory) -> Void)?
    var onCategorySelectedForEditing: ((TrackerCategory) -> Void)?
    
    var selectedCategory: TrackerCategory? {
        didSet {
            guard let category = selectedCategory else { return }
            onCategorySelected?(category)
        }
    }
    
    // MARK: - Private Properties
    
    private var categoryProvider: TrackerCategoryProviderProtocol
    private var state: CategoriesViewModelState = .empty(update: .init()) {
        didSet { onStateChange?(state) }
    }
    
    // MARK: - Initialization
    
    init(_ categoryProvider: TrackerCategoryProviderProtocol) {
        self.categoryProvider = categoryProvider
        self.categoryProvider.delegate = self
    }
}

// MARK: - Internal Methods

extension CategoriesViewModel {
    
    func numberOfRows(in section: Int) -> Int {
        categoryProvider.numberOfRows(in: section)
    }
    
    func categoryTitle(at indexPath: IndexPath) -> String? {
        categoryProvider.category(at: indexPath)?.title
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        guard let category = categoryProvider.category(at: indexPath) else { return }
        selectedCategory = category
    }
    
    func isCategorySelected(at indexPath: IndexPath) -> Bool {
        guard let category = categoryProvider.category(at: indexPath) else { return false }
        return selectedCategory == category
    }
    
    func reloadState() {
        determineState(TrackerCategoryStoreUpdate())
    }
    
    func editCategory(at indexPath: IndexPath) {
        guard let category = categoryProvider.category(at: indexPath) else { return }
        onCategorySelectedForEditing?(category)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        try? categoryProvider.deleteCategory(at: indexPath)
    }
    
}

// MARK: - Private Methods

private extension CategoriesViewModel {
    
    func determineState(_ update: TrackerCategoryStoreUpdate) {
        if categoryProvider.numberOfCategories() > 0 {
            state = .content(update: update)
        } else {
            state = .empty(update: update)
        }
    }
    
}

// MARK: - TrackerCategoryProviderDelegate

extension CategoriesViewModel: TrackerCategoryProviderDelegate {
    
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.determineState(update)
        }
    }
    
}
