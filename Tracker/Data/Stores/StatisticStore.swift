//
//  StatisticStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import Foundation

enum StatisticKey: String {
    case bestPeriod
    case perfectDays
    case completedTrackers
    case averageValue
}

final class StatisticStore {
    
    private let defaults = UserDefaults.standard

    var bestPeriod: Int {
        get { defaults.integer(forKey: StatisticKey.bestPeriod.rawValue) }
        set { defaults.set(newValue, forKey: StatisticKey.bestPeriod.rawValue) }
    }

    var perfectDays: Int {
        get { defaults.integer(forKey: StatisticKey.perfectDays.rawValue) }
        set { defaults.set(newValue, forKey: StatisticKey.perfectDays.rawValue) }
    }

    var completedTrackers: Int {
        get { defaults.integer(forKey: StatisticKey.completedTrackers.rawValue) }
        set { defaults.set(newValue, forKey: StatisticKey.completedTrackers.rawValue) }
    }

    var averageValue: Int {
        get { defaults.integer(forKey: StatisticKey.averageValue.rawValue) }
        set { defaults.set(newValue, forKey: StatisticKey.averageValue.rawValue) }
    }
    
}
