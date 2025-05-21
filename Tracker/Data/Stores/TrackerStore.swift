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
    func edit(_ tracker: Tracker, to newTracker: Tracker, newCategory: TrackerCategory) throws
    func delete(_ tracker: Tracker) throws
    func togglePin(for tracker: Tracker) throws
    func fetchTrackerEntity(by id: UUID) throws -> TrackerEntity?
    func fetchTrackerIDs(for date: Date) throws -> Set<UUID>
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
        trackerEntity.isPinned = tracker.isPinned
        trackerEntity.createdAt = Date()
        trackerEntity.sectionName = tracker.isPinned ? "0" + .pinned : category.title
        
        trackerEntity.schedule = tracker.schedule?
            .map { String($0.rawValue) }
            .joined(separator: ",")
        
        let categoryEntity = try categoryStore.fetchOrCreateCategory(withTitle: category.title)
        categoryEntity.addToTrackers(trackerEntity)
        trackerEntity.category = categoryEntity
    
        try context.save()
    }
    
    func edit(_ tracker: Tracker, to newTracker: Tracker, newCategory: TrackerCategory) throws {
        guard let trackerEntity = try fetchTrackerEntity(by: tracker.id) else { return }

        trackerEntity.title = newTracker.title
        trackerEntity.emoji = newTracker.emoji
        trackerEntity.color = newTracker.color.hexString
        trackerEntity.isPinned = newTracker.isPinned
        trackerEntity.schedule = newTracker.schedule?
            .map { String($0.rawValue) }
            .joined(separator: ",")
        
        trackerEntity.sectionName = newTracker.isPinned ? "0" + .pinned : newCategory.title
        
        if trackerEntity.category?.title != newCategory.title {
            let newCategoryEntity = try categoryStore.fetchOrCreateCategory(withTitle: newCategory.title)
            trackerEntity.category?.removeFromTrackers(trackerEntity)
            trackerEntity.category = newCategoryEntity
            newCategoryEntity.addToTrackers(trackerEntity)
        }

        try context.save()
    }
    
    func delete(_ tracker: Tracker) throws {
        guard let trackerEntity = try fetchTrackerEntity(by: tracker.id) else { return }
        context.delete(trackerEntity)
        try context.save()
    }
    
    func togglePin(for tracker: Tracker) throws {
        guard let trackerEntity = try fetchTrackerEntity(by: tracker.id) else { return }
        trackerEntity.isPinned.toggle()
        trackerEntity.sectionName = trackerEntity.isPinned ? "0" + .pinned : trackerEntity.category?.title
        try context.save()
    }
    
    func fetchTrackerEntity(by id: UUID) throws -> TrackerEntity? {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    func fetchTrackerIDs(for date: Date) throws -> Set<UUID> {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        guard let currentDay = Day(rawValue: weekday) else { return Set() }
        
        let startOfDay = calendar.startOfDay(for: date)
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let scheduledPredicate = NSPredicate(format: "schedule != nil AND schedule CONTAINS %@", "\(currentDay.rawValue)")

        let oneTimePredicate = NSPredicate(
            format: "schedule == nil AND SUBQUERY(records, $r, $r.date >= %@ AND $r.date < %@).@count > 0",
            startOfDay as NSDate,
            startOfNextDay as NSDate
        )
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            scheduledPredicate,
            oneTimePredicate
        ])
        
        request.predicate = predicate
        
        let trackers = try context.fetch(request)
        return Set(trackers.compactMap { $0.id })
    }
    
}


extension TrackerEntity {
    
    var scheduleDays: [Day]? {
        get {
            guard let schedule = self.schedule else { return nil }
            return schedule
                .split(separator: ",")
                .compactMap { Int($0) }
                .compactMap { Day(rawValue: $0) }
        }
        set {
            if let newValue = newValue {
                let string = newValue.map { String($0.rawValue) }.joined(separator: ",")
                self.schedule = string
            } else {
                self.schedule = nil
            }
        }
    }
    
}
