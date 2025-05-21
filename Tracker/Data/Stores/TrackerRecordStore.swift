//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 17.04.2025.
//

import CoreData

protocol TrackerRecordStoreProtocol {
    func add(_ record: TrackerRecord) throws
    func delete(_ record: TrackerRecord) throws
    func fetchRecord(for: UUID, on: Date) throws -> TrackerRecordEntity?
    func fetchCompletedRecords(for: UUID) throws -> [TrackerRecordEntity]
    func completedTrackersCount() throws -> Int
    func fetchAllCompletionDates() throws -> [Date]
}

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStoreProtocol
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStoreProtocol) {
        self.context = context
        self.trackerStore = trackerStore
    }
    
    func add(_ record: TrackerRecord) throws {
        let entity = TrackerRecordEntity(context: context)
        entity.id = record.id
        
        entity.date = record.date
        
        if let trackerEntity = try trackerStore.fetchTrackerEntity(by: record.id) {
            entity.tracker = trackerEntity
            trackerEntity.addToRecords(entity)
        }
        
        try context.save()
        
        NotificationCenter.default.post(name: .statisticsShouldRefresh, object: nil)
    }
    
    func delete(_ record: TrackerRecord) throws {
        guard let entity = try fetchRecord(for: record.id, on: record.date) else { return }
        
        context.delete(entity)
        
        try context.save()
        
        NotificationCenter.default.post(name: .statisticsShouldRefresh, object: nil)
    }
    
    func fetchRecord(for id: UUID, on date: Date) throws -> TrackerRecordEntity? {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()

        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.endOfDay(for: date) else {
            return nil
        }

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", id as CVarArg),
            NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        ])
        fetchRequest.fetchLimit = 1
        
        return try context.fetch(fetchRequest).first
    }
    
    func fetchCompletedRecords(for id: UUID) throws -> [TrackerRecordEntity] {
        let request: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        return try context.fetch(request)
    }
    
    func completedTrackersCount() throws -> Int {
        let request: NSFetchRequest<NSNumber> = NSFetchRequest(entityName: "TrackerRecordEntity")
        request.resultType = .countResultType

        let count = try context.count(for: request)
        return count
    }

    func fetchAllCompletionDates() throws -> [Date] {
        let request: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "TrackerRecordEntity")
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.propertiesToFetch = ["date"]
        
        let result = try context.fetch(request)
        let dates = result.compactMap { $0["date"] as? Date }
        
        return dates.sorted()
    }
    
}
