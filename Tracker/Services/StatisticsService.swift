//
//  StatisticsService.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import Foundation

final class StatisticsService {
    
    private var store: StatisticStoreProtocol
    private let recordProvider: TrackerRecordProviderProtocol
    
    init(store: StatisticStoreProtocol, recordStore: TrackerRecordProviderProtocol) {
        self.store = store
        self.recordProvider = recordStore
    }
    
}

// MARK: - Internal Methods

extension StatisticsService {
    
    func recalculateStatistics() {
        let bestPeriod = calculateBestPeriod()
        store.bestPeriod = bestPeriod

        let perfectDays = calculatePerfectDays()
        store.perfectDays = perfectDays

        let completed = calculateCompletedTrackersCount()
        store.completedTrackers = completed

        let average = calculateAverageValue()
        store.averageValue = average
    }

    func fetchStatistics() -> [StatisticItem] {
        return [
            StatisticItem(value: store.bestPeriod, title: .bestPeriod),
            StatisticItem(value: store.perfectDays, title: .perfectDays),
            StatisticItem(value: store.completedTrackers, title: .trackersCompleted),
            StatisticItem(value: store.averageValue, title: .averageValue)
        ]
    }
    
}

// MARK: - Private Methods

private extension StatisticsService {
    
    private func calculateBestPeriod() -> Int {
        return 0
    }

    private func calculatePerfectDays() -> Int {
        return 0
    }
    
    func calculateCompletedTrackersCount() -> Int {
        do {
            return try recordProvider.completedTrackersCount()
        } catch {
            print("Failed to count completed trackers: \(error)")
            return 0
        }
    }

    private func calculateAverageValue() -> Int {
        return 0
    }
    
}
