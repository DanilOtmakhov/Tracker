//
//  Day.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import Foundation

enum Day: Int, CaseIterable {
    
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var string: String {
        switch self {
        case .monday: return .monday
        case .tuesday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
    }
    
    var shortString: String {
        switch self {
        case .monday: return .mondayShort
        case .tuesday: return .tuesdayShort
        case .wednesday: return .wednesdayShort
        case .thursday: return .thursdayShort
        case .friday: return .fridayShort
        case .saturday: return .saturdayShort
        case .sunday: return .sundayShort
        }
    }
    
}

extension Day: Comparable {
    
    static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}
