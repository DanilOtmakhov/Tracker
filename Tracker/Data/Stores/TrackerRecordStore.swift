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
        
        try trackerStore.addToRecords(entity)
    }
    
    func delete(_ record: TrackerRecord) throws {
        guard
            let entity = try fetchRecord(for: record.id, on: record.date)
        else { return }
        
        context.delete(entity)
        
        try context.save()
    }
    
    func fetchRecord(for id: UUID, on date: Date) throws -> TrackerRecordEntity? {
        let fetchRequest: NSFetchRequest<TrackerRecordEntity> = TrackerRecordEntity.fetchRequest()

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
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
    
}
