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
    func numberOfRowsInSection(_ section: Int) -> Int
    func categoryTitle(at indexPath: IndexPath) -> String?
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((CategoriesViewModelState) -> Void)?
    
    // MARK: - Private Properties
    
    var categories = TrackerCategory.mockData
    
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
        categories[indexPath.row].title
    }
    
}
