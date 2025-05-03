//
//  DataManager.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import Foundation

protocol DataManagerProtocol {
    var trackerProvider: TrackerProviderProtocol { get set }
    var categoryProvider: TrackerCategoryProviderProtocol { get }
    var recordProvider: TrackerRecordProviderProtocol { get }
}

final class DataManager: DataManagerProtocol {
    
    var trackerProvider: TrackerProviderProtocol
    let categoryProvider: TrackerCategoryProviderProtocol
    let recordProvider: TrackerRecordProviderProtocol
    
    init() {
        let trackerCategoryStore = TrackerCategoryStore(context: CoreDataStack.shared.context)
        let trackerDataStore = TrackerStore(context: CoreDataStack.shared.context, categoryStore: trackerCategoryStore)
        let trackerRecordStore = TrackerRecordStore(context: CoreDataStack.shared.context, trackerStore: trackerDataStore)
        
        self.trackerProvider = TrackerProvider(
            store: trackerDataStore,
            context: CoreDataStack.shared.context
        )
        self.categoryProvider = TrackerCategoryProvider(
            store: trackerCategoryStore,
            context: CoreDataStack.shared.context
        )
        self.recordProvider = TrackerRecordProvider(
            store: trackerRecordStore,
            context: CoreDataStack.shared.context
        )
    }
    
}
