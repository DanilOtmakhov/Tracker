//
//  Calendar+Extensions.swift
//  Tracker
//
//  Created by Danil Otmakhov on 03.05.2025.
//

import Foundation

extension Calendar {
    
    static func endOfDay(for date: Date) -> Date? {
        let startOfDay = current.startOfDay(for: date)
        return current.date(byAdding: .day, value: 1, to: startOfDay)
    }
    
}
