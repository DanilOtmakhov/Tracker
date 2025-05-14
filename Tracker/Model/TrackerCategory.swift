//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Danil Otmakhov on 31.03.2025.
//

import Foundation

struct TrackerCategory {
    
    let title: String
    let trackers: [Tracker]
    
    static func from(_ entity: TrackerCategoryEntity) -> TrackerCategory? {
        guard
            let title = entity.title,
            let trackerEntities = entity.trackers as? Set<TrackerEntity>
        else {
            return nil
        }
        
        let trackers = trackerEntities.compactMap { Tracker.from($0) }

        return TrackerCategory(title: title, trackers: trackers)
    }
    
}

extension TrackerCategory: Equatable {
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title == rhs.title
    }
    
}
