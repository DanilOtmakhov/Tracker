//
//  TrackerStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 02.04.2025.
//

import Foundation

protocol TrackerStoreProtocol {
    
    func fetchTrackerCategories() -> [TrackerCategory]
    
}

final class TrackerStore: TrackerStoreProtocol {
    
    private var trackerCategories: [TrackerCategory] = TrackerCategory.mockData
    
    func fetchTrackerCategories() -> [TrackerCategory] {
        trackerCategories
    }
    
}
