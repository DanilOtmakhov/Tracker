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

    static let mockData: [TrackerCategory] = [
        TrackerCategory(title: "Важное", trackers: []),
        TrackerCategory(title: "Не важное", trackers: []),
        TrackerCategory(title: "1", trackers: []),
        TrackerCategory(title: "2", trackers: []),
        TrackerCategory(title: "3", trackers: []),
        TrackerCategory(title: "4", trackers: []),
        TrackerCategory(title: "5", trackers: []),
        TrackerCategory(title: "6", trackers: []),
        TrackerCategory(title: "7", trackers: []),
        TrackerCategory(title: "8", trackers: [])
    ]
    
}

extension TrackerCategory: Equatable {
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title == rhs.title
    }
    
}
