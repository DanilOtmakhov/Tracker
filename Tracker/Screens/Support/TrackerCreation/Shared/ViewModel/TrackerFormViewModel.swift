//
//  TrackerFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import Foundation

protocol TrackerFormViewModelProtocol {
    
    var title: String? { get set }
    var selectedCategory: String? { get set }
    
    var isFormValid: Bool { get }
    
    var onFormUpdated: (() -> Void)? { get set }
    
    func didEnterTitle(_ title: String?)
    func didSelectCategory(_ category: String)
    
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
    
    var isFormValid: Bool {
        guard let title, !title.isEmpty else { return false }
        guard selectedCategory != nil else { return false }
        return true
    }
    
    var onFormUpdated: (() -> Void)?
    
    // MARK: - Private Properties
    
    let trackerStore: TrackerCreationStoreProtocol
    
    // MARK: - Initialization
    
    init(trackerStore: TrackerCreationStoreProtocol) {
        self.trackerStore = trackerStore
    }
    
    // MARK: - Internal Methods
    
    func didEnterTitle(_ title: String?) {
        self.title = title
    }
    
    func didSelectCategory(_ category: String) {
        self.selectedCategory = category
    }
    
    func createTracker() {
        guard let title,
              let selectedCategory
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            title: title,
            emoji: "😊",
            color: .color4,
            schedule: nil
        )
        
        let category = TrackerCategory(title: selectedCategory, trackers: [tracker])
        
        trackerStore.addTracker(category)
    }
    
}
