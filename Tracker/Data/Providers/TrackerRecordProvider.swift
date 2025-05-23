//
//  TrackerRecordProvider.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import CoreData

protocol TrackerRecordProviderProtocol {
    func isTrackerCompleted(_ id: UUID, on: Date) -> Bool
    func completedDaysCount(for: UUID) -> Int
    func addRecord(_ record: TrackerRecord) throws
    func deleteRecord(_ record: TrackerRecord) throws
    func completedTrackersCount() throws -> Int
    func fetchAllCompletionDates() throws -> [Date]
    func fetchCompletionsGroupedByDate() throws -> [Date: Set<UUID>]
}

final class TrackerRecordProvider: NSObject {
    
    private let context: NSManagedObjectContext
    private let store: TrackerRecordStoreProtocol
    
    init(store: TrackerRecordStoreProtocol, context: NSManagedObjectContext) {
        self.store = store
        self.context = context
    }
    
}

// MARK: - TrackerRecordDataProviderProtocol

extension TrackerRecordProvider: TrackerRecordProviderProtocol {
    
    func isTrackerCompleted(_ id: UUID, on date: Date) -> Bool {
        do {
            return try store.fetchRecord(for: id, on: date) != nil
        } catch {
            print("Error fetching tracker record: \(error)")
            return false
        }
    }
    
    func completedDaysCount(for id: UUID) -> Int {
        do {
            return try store.fetchCompletedRecords(for: id).count
        } catch {
            print("Error fetching completed tracker records: \(error)")
            return 0
        }
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        try store.add(record)
    }
    
    func deleteRecord(_ record: TrackerRecord) throws {
        try store.delete(record)
    }
    
    func completedTrackersCount() throws -> Int {
        try store.completedTrackersCount()
    }
    
    func fetchAllCompletionDates() throws -> [Date] {
        try store.fetchAllCompletionDates()
    }
    
    func fetchCompletionsGroupedByDate() throws -> [Date: Set<UUID>] {
        try store.fetchCompletionsGroupedByDate()
    }
    
}
