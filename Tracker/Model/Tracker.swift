//
//  Tracker.swift
//  Tracker
//
//  Created by Danil Otmakhov on 31.03.2025.
//

import UIKit

struct Tracker {
    
    let id: UUID
    let title: String
    let emoji: String
    let color: UIColor
    let schedule: [Day]?
    
    static func from(_ entity: TrackerEntity) -> Tracker? {
        guard let id = entity.id,
              let title = entity.title,
              let emoji = entity.emoji,
              let colorHex = entity.color,
              let color = UIColor(from: colorHex) else {
            return nil
        }
        
        let schedule = entity.schedule as? [Day]
        
        return Tracker(
            id: id,
            title: title,
            emoji: emoji,
            color: color,
            schedule: schedule
        )
    }
    
}
