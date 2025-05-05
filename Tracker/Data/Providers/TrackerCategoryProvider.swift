//
//  TrackerCategoryProvider.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import CoreData

protocol TrackerCategoryProviderProtocol {
    
}

final class TrackerCategoryProvider: NSObject {
    
    private let context: NSManagedObjectContext
    private let store: TrackerCategoryStoreProtocol
    
    init(store: TrackerCategoryStoreProtocol, context: NSManagedObjectContext) {
        self.store = store
        self.context = context
    }
    
}

// MARK: - TrackerCategoryDataProviderProtocol

extension TrackerCategoryProvider: TrackerCategoryProviderProtocol {

}

