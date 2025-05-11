//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.05.2025.
//

import Foundation

enum CategoriesViewModelState {
    case content
    case empty
}

protocol CategoriesViewModelProtocol {
    var onStateChange: ((CategoriesViewModelState) -> Void)? { get set }
    var onCategorySelected: ((TrackerCategory) -> Void)? { get set }
    func numberOfRowsInSection(_ section: Int) -> Int
    func categoryTitle(at indexPath: IndexPath) -> String?
    func didSelectCategory(at indexPath: IndexPath)
    func isCategorySelected(at indexPath: IndexPath) -> Bool
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((CategoriesViewModelState) -> Void)?
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Internal Properties
    
    var selectedCategory: TrackerCategory? {
        didSet {
            guard let category = selectedCategory else { return }
            onCategorySelected?(category)
        }
    }
    
    // MARK: - Private Properties
    
    private var categories = TrackerCategory.mockData
    private var state: CategoriesViewModelState = .empty {
        didSet { onStateChange?(state) }
    }
    
}

// MARK: - Internal Methods

extension CategoriesViewModel {
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        categories.count
    }
    
    func categoryTitle(at indexPath: IndexPath) -> String? {
        guard indexPath.row < categories.count else { return nil }
        return categories[indexPath.row].title
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else { return }
        selectedCategory = categories[indexPath.row]
    }
    
    func isCategorySelected(at indexPath: IndexPath) -> Bool {
        guard indexPath.row < categories.count else { return false }
        return selectedCategory == categories[indexPath.row]
    }
    
}
