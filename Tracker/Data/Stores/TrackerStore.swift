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
    func fetchTrackerEntity(by id: UUID) throws -> TrackerEntity?
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
        
        if let schedule = tracker.schedule {
            trackerEntity.schedule = schedule.map { String($0.rawValue) }.joined(separator: ",")
        } else {
            trackerEntity.schedule = nil
        }
        
        let categoryEntity = try categoryStore.fetchOrCreateCategory(withTitle: category.title)
        categoryEntity.addToTrackers(trackerEntity)
        trackerEntity.category = categoryEntity
    
        try context.save()
    }
    
    func fetchTrackerEntity(by id: UUID) throws -> TrackerEntity? {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
}


extension TrackerEntity {
    var scheduleDays: [Day] {
        get {
            guard let schedule = self.schedule else { return [] }
            return schedule
                .split(separator: ",")
                .compactMap { Int($0) }
                .compactMap { Day(rawValue: $0) }
        }
        set {
            let string = newValue.map { String($0.rawValue) }.joined(separator: ",")
            self.schedule = string
        }
    }
}
