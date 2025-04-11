//
//  TrackerStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 02.04.2025.
//

import Foundation

protocol TrackerStoreProtocol {
    var onTrackerAdded: (() -> Void)? { get set }
    func fetchTrackerCategories() -> [TrackerCategory]
    func fetchCompletedTrackers() -> Set<TrackerRecord>
}

protocol TrackerCreationStoreProtocol {
    func addTracker(_ trackerCategory: TrackerCategory)
}

final class TrackerStore: TrackerStoreProtocol, TrackerCreationStoreProtocol {
    
    var onTrackerAdded: (() -> Void)?
    
    private var trackerCategories: [TrackerCategory] = []
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
