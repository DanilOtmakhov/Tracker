//
//  TrackerStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 02.04.2025.
//

import Foundation

protocol TrackerStoreProtocol {
    
    func fetchTrackerCategories() -> [TrackerCategory]
    func fetchCompletedTrackers() -> Set<TrackerRecord>
    
}

final class TrackerStore: TrackerStoreProtocol {
    
    private var trackerCategories: [TrackerCategory] = TrackerCategory.mockData
    private var completedTrackers: Set<TrackerRecord> = []
    
    func fetchTrackerCategories() -> [TrackerCategory] {
        trackerCategories
    }
    
    func fetchCompletedTrackers() -> Set<TrackerRecord> {
        completedTrackers
    }
    
}
