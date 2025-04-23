//
//  TrackerStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 17.04.2025.
//

import CoreData
import UIKit

protocol TrackerStoreProtocol {
    func add(_ tracker: Tracker, to category: TrackerCategory) throws
    func addToRecords(_ recordEntity: TrackerRecordEntity) throws
}

final class TrackerStore: TrackerStoreProtocol {
    
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStoreProtocol
    
    init(context: NSManagedObjectContext, categoryStore: TrackerCategoryStore) {
        self.context = context
        self.categoryStore = categoryStore
    }
    
    func add(_ tracker: Tracker, to category: TrackerCategory) throws {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = tracker.color.hexString
        trackerEntity.schedule = tracker.schedule as NSArray?
        
        let categoryEntity = try categoryStore.fetchOrCreateCategory(withTitle: category.title)
        categoryEntity.addToTrackers(trackerEntity)
        
        try context.save()
    }
    
    func addToRecords(_ recordEntity: TrackerRecordEntity) throws {
        guard
            let id = recordEntity.id,
            let trackerEntity = try fetchTrackerEntity(by: id) else
        {
            return
        }
        trackerEntity.addToRecords(recordEntity)

        try context.save()
    }
    
    private func fetchTrackerEntity(by id: UUID) throws -> TrackerEntity? {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        let result = try context.fetch(request).first

        return result
    }
    
}
