//
//  StatisticsService.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import Foundation

final class StatisticsService {
    
    private var store: StatisticStoreProtocol
    private let dataManager: DataManagerProtocol
    
    init(store: StatisticStoreProtocol, dataManager: DataManagerProtocol) {
        self.store = store
        self.dataManager = dataManager
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
        do {
            let dates = try dataManager.recordProvider.fetchAllCompletionDates()
            let sortedDates = dates.map { Calendar.current.startOfDay(for: $0) }
                                   .sorted()
            
            guard !sortedDates.isEmpty else { return 0 }
            
            var maxStreak = 1
            var currentStreak = 1
            
            for i in 1..<sortedDates.count {
                let prev = sortedDates[i - 1]
                let current = sortedDates[i]
                
                if Calendar.current.date(byAdding: .day, value: 1, to: prev) == current {
                    currentStreak += 1
                    maxStreak = max(maxStreak, currentStreak)
                } else if prev != current {
                    currentStreak = 1
                }
            }
            
            return maxStreak
        } catch {
            print("Failed to calculate best period: \(error)")
            return 0
        }
    }


    private func calculatePerfectDays() -> Int {
        do {
            let completionMap = try dataManager.recordProvider.fetchCompletionsGroupedByDate()
            var perfectDayCount = 0

            for (date, completedTrackers) in completionMap {
                let trackers = try dataManager.trackerProvider.fetchTrackerIDs(for: date)

                if !trackers.isEmpty && trackers == completedTrackers {
                    perfectDayCount += 1
                }
            }
            
            return perfectDayCount
        } catch {
            print("Failed to calculate perfect days: \(error)")
            return 0
        }
    }

    
    func calculateCompletedTrackersCount() -> Int {
        do {
            return try dataManager.recordProvider.completedTrackersCount()
        } catch {
            print("Failed to count completed trackers: \(error)")
            return 0
        }
    }

    private func calculateAverageValue() -> Int {
        do {
            let completionMap = try dataManager.recordProvider.fetchCompletionsGroupedByDate()
            let totalDays = completionMap.keys.count
            let totalCompletions = completionMap.values.reduce(0) { $0 + $1.count }

            guard totalDays > 0 else { return 0 }
            
            return Int(round(Double(totalCompletions) / Double(totalDays)))
        } catch {
            print("Failed to calculate average value: \(error)")
            return 0
        }
    }

    
}
