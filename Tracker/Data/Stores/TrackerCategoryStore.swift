//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Danil Otmakhov on 17.04.2025.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case categoryAlreadyExists(String)
    case categoryNotFound(String)
}

protocol TrackerCategoryStoreProtocol {
    func fetchCategories() throws -> [TrackerCategory]
    func fetchOrCreateCategory(withTitle title: String) throws -> TrackerCategoryEntity
    func addCategory(withTitle title: String) throws
    func delete(_ category: TrackerCategory) throws
}

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        
        let categoryEntities = try context.fetch(request)

        return categoryEntities.compactMap { entity -> TrackerCategory? in
            guard let title = entity.title,
                  let trackersSet = entity.trackers as? Set<TrackerEntity> else {
                return nil
            }

            let trackers = trackersSet.compactMap { Tracker.from($0) }
            
            return TrackerCategory(title: title, trackers: trackers)
        }
    }
    
    func fetchOrCreateCategory(withTitle title: String) throws -> TrackerCategoryEntity {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1

        if let category = try context.fetch(request).first {
            return category
        } else {
            let newCategory = TrackerCategoryEntity(context: context)
            newCategory.title = title
            newCategory.createdAt = Date()
            return newCategory
        }
    }
    
    func addCategory(withTitle title: String) throws {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        if let _ = try context.fetch(request).first {
            throw TrackerCategoryStoreError.categoryAlreadyExists("Category with title '\(title)' already exists")
        }
        
        let newCategory = TrackerCategoryEntity(context: context)
        newCategory.title = title
        newCategory.createdAt = Date()
        
        try context.save()
    }
    
    func delete(_ category: TrackerCategory) throws {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", category.title)
        request.fetchLimit = 1
        
        let results = try context.fetch(request)
        
        guard let categoryToDelete = results.first else {
            throw TrackerCategoryStoreError.categoryNotFound("Category '\(category.title)' not found")
        }
        
        if let trackers = categoryToDelete.trackers as? Set<TrackerEntity> {
            for tracker in trackers {
                context.delete(tracker)
            }
        }
        
        context.delete(categoryToDelete)
        
        try context.save()
    }
    
}
 
