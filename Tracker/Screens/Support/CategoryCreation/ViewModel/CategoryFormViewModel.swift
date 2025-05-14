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
    var isEditMode: Bool { get }
    var initialTitle: String? { get }
    var onStateChange: ((CategoryFormViewModelState) -> Void)? { get set }
    var onCategoryAdded: (() -> Void)? { get set }
    func completeForm(withTitle title: String)
    func updateTitle(_ title: String?)
}

final class CategoryFormViewModel: CategoryFormViewModelProtocol {
    
    var onCategoryAdded: (() -> Void)?
    var onStateChange: ((CategoryFormViewModelState) -> Void)?
    
    private(set) var isEditMode: Bool
    private(set) var initialTitle: String?
    
    private let categoryToEdit: TrackerCategory?
    private let categoryProvider: TrackerCategoryProviderProtocol
    private let maxTitleLength: Int = 38
    private var state: CategoryFormViewModelState = .initial {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(categoryProvider: TrackerCategoryProviderProtocol, categoryToEdit: TrackerCategory? = nil) {
        self.categoryProvider = categoryProvider
        self.categoryToEdit = categoryToEdit
        self.isEditMode = categoryToEdit != nil
        self.initialTitle = categoryToEdit?.title
    }
    
}

// MARK: - Internal Methods

extension CategoryFormViewModel {
    
    func completeForm(withTitle title: String) {
        do {
            if isEditMode {
                guard let categoryToEdit else { return }
                try categoryProvider.edit(categoryToEdit, withTitle: title)
                NotificationCenter.default.post(name: .trackersShouldRefresh, object: nil)
            } else {
                try categoryProvider.addCategory(withTitle: title)
            }
            onCategoryAdded?()
        } catch {
            print("Failed to add category: \(error)")
        }
    }
    
    func updateTitle(_ title: String?) {
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
