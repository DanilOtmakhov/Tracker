//
//  TrackerFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

protocol TrackerFormViewModelProtocol {
    
    var title: String? { get set }
    var selectedCategory: String? { get set }
    var selectedEmoji: String? { get set }
    var selectedColor: UIColor? { get set }
    
    var isFormValid: Bool { get }
    
    var onFormUpdated: (() -> Void)? { get set }
    
    func didEnterTitle(_ title: String?)
    func didSelectCategory(_ category: String)
    func didSelectEmoji(_ emoji: String)
    func didSelectColor(_ color: UIColor)
    
    func createTracker()
    
}

class TrackerFormViewModel: TrackerFormViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var title: String? {
        didSet {
            onFormUpdated?()
        }
    }
    
    var selectedCategory: String? = "Важное" {
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
        guard let title,
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
    
    // MARK: - Private Properties
    
    let trackerStore: MockTrackerCreationStoreProtocol
    
    // MARK: - Initialization
    
    init(trackerStore: MockTrackerCreationStoreProtocol) {
        self.trackerStore = trackerStore
    }
    
    // MARK: - Internal Methods
    
    func didEnterTitle(_ title: String?) {
        self.title = title
    }
    
    func didSelectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
    
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func createTracker() {
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
        
        let category = TrackerCategory(title: selectedCategory, trackers: [tracker])
        
        trackerStore.addTracker(category)
    }
    
}
