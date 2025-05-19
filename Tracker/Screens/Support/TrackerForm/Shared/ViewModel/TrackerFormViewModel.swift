//
//  TrackerFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

protocol TrackerFormViewModelProtocol: AnyObject {
    
    var isEditMode: Bool { get }
    
    var title: String? { get set }
    var selectedCategory: TrackerCategory? { get set }
    var selectedEmoji: String? { get set }
    var selectedColor: UIColor? { get set }
    
    var isFormValid: Bool { get }
    
    var onFormUpdated: (() -> Void)? { get set }
    
    func enterTitle(_ title: String?)
    func selectCategory(_ category: TrackerCategory)
    func selectEmoji(_ emoji: String)
    func selectColor(_ color: UIColor)
    
    func completeForm()
    
    func completedDaysCount() -> Int?
}

class TrackerFormViewModel: TrackerFormViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            onFormUpdated?()
        }
    }
    
    var selectedCategory: TrackerCategory? {
        didSet {
            onFormUpdated?()
        }
    }
    
    var selectedEmoji: String? {
        didSet {
            onFormUpdated?()
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            onFormUpdated?()
        }
    }
    
    var isFormValid: Bool {
        guard
            let title,
            !title.isEmpty,
            selectedCategory != nil,
            selectedEmoji != nil,
            selectedColor != nil
        else {
            return false
        }
        
        return true
    }
    
    var onFormUpdated: (() -> Void)?
    var dataManager: DataManagerProtocol
    
    // MARK: - Private Properties
    
    var isEditMode: Bool
    var trackerToEdit: Tracker?
    
    // MARK: - Initialization
    
    init(dataManager: DataManagerProtocol, trackerToEdit: Tracker? = nil) {
        self.dataManager = dataManager
        self.trackerToEdit = trackerToEdit
        isEditMode = trackerToEdit != nil
        
        if let tracker = trackerToEdit {
            title = tracker.title
            selectedCategory = try? dataManager.categoryProvider.category(of: tracker)
            selectedColor = tracker.color
            selectedEmoji = tracker.emoji
        }
        
        onFormUpdated?()
    }
    
    // MARK: - Internal Methods
    
    func enterTitle(_ title: String?) {
        self.title = title
    }
    
    func selectCategory(_ category: TrackerCategory) {
        selectedCategory = category
    }
    
    func selectEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
    
    func selectColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func completeForm() {
        if isEditMode {
            // TODO: edit tracker call
        } else {
            guard let title,
                  let selectedCategory,
                  let selectedEmoji,
                  let selectedColor
            else { return }
            
            let tracker = Tracker(
                id: UUID(),
                title: title,
                emoji: selectedEmoji,
                color: selectedColor,
                schedule: nil
            )
            
            try? dataManager.trackerProvider.addTracker(tracker, to: selectedCategory)
        }
    }
    
    func completedDaysCount() -> Int? {
        guard let trackerToEdit else { return nil}
        return dataManager.recordProvider.completedDaysCount(for: trackerToEdit.id)
    }
    
}
