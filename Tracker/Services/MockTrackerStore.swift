//
//  TrackerStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 02.04.2025.
//

import Foundation

protocol MockTrackerStoreProtocol {
    var onTrackerAdded: (() -> Void)? { get set }
    func fetchTrackerCategories() -> [TrackerCategory]
    func fetchCompletedTrackers() -> Set<TrackerRecord>
}

protocol MockTrackerCreationStoreProtocol {
    func addTracker(_ trackerCategory: TrackerCategory)
}

final class MockTrackerStore: MockTrackerStoreProtocol, MockTrackerCreationStoreProtocol {
    
    var onTrackerAdded: (() -> Void)?
    
    private var trackerCategories: [TrackerCategory] = TrackerCategory.mockData
    private var completedTrackers: Set<TrackerRecord> = []
    
    func fetchTrackerCategories() -> [TrackerCategory] {
        trackerCategories
    }
    
    func fetchCompletedTrackers() -> Set<TrackerRecord> {
        completedTrackers
    }
    
    func addTracker(_ trackerCategory: TrackerCategory) {
        if let existingCategoryIndex = trackerCategories.firstIndex(where: { $0.title == trackerCategory.title }) {
            let existingCategory = trackerCategories[existingCategoryIndex]
            let updatedTrackers = existingCategory.trackers + trackerCategory.trackers
            let updatedCategory = TrackerCategory(title: existingCategory.title, trackers: updatedTrackers)
            
            var updatedCategories = trackerCategories
            updatedCategories[existingCategoryIndex] = updatedCategory
            trackerCategories = updatedCategories
        } else {
            trackerCategories.append(trackerCategory)
        }
        
        onTrackerAdded?()
    }
    
}
