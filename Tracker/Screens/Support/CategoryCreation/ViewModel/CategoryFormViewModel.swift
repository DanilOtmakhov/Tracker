//
//  CategoryFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 12.05.2025.
//

import Foundation

enum CategoryFormViewModelState {
    case initial
    case validInput(text: String)
    case atCharacterLimit(text: String)
}

protocol CategoryFormViewModelProtocol {
    var onStateChange: ((CategoryFormViewModelState) -> Void)? { get set }
    var onFormCompleted: (() -> Void)? { get set }
    func didCompleteForm(withTitle title: String)
    func didChangeTitle(_ title: String?)
}

final class CategoryFormViewModel: CategoryFormViewModelProtocol {
    
    var onFormCompleted: (() -> Void)?
    var onStateChange: ((CategoryFormViewModelState) -> Void)?
    
    private let categoryProvider: TrackerCategoryProviderProtocol
    private let maxTitleLength: Int = 38
    private var state: CategoryFormViewModelState = .initial {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(categoryProvider: TrackerCategoryProviderProtocol) {
        self.categoryProvider = categoryProvider
    }
    
}

// MARK: - Internal Methods

extension CategoryFormViewModel {
    
    func didCompleteForm(withTitle title: String) {
        do {
            try categoryProvider.addCategory(withTitle: title)
            onFormCompleted?()
        } catch {
            print("Failed to add category: \(error)")
        }
    }
    
    func didChangeTitle(_ title: String?) {
        let text = title ?? ""
        if text.count >= maxTitleLength {
            state = .atCharacterLimit(text: text)
        } else if !text.isEmpty {
            state = .validInput(text: text)
        } else {
            state = .initial
        }
    }
    
}
