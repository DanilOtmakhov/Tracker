//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Danil Otmakhov on 31.03.2025.
//

import Foundation

struct TrackerRecord: Hashable {
    
    let id: UUID
    let date: Date
    
    static func from(_ entity: TrackerRecordEntity) -> TrackerRecord? {
        guard let id = entity.id,
              let date = entity.date
        else {
            return nil
        }
        
        return TrackerRecord(id: id, date: date)
    }
    
}
