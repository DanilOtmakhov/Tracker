//
//  DataManager.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import CoreData

protocol DataManagerProtocol {
    var trackerProvider: TrackerProviderProtocol { get set }
    var categoryProvider: TrackerCategoryProviderProtocol { get }
    var recordProvider: TrackerRecordProviderProtocol { get }
}

final class DataManager: DataManagerProtocol {
    
    let context: NSManagedObjectContext
    
    var trackerProvider: TrackerProviderProtocol
    let categoryProvider: TrackerCategoryProviderProtocol
    let recordProvider: TrackerRecordProviderProtocol
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
        
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        let trackerDataStore = TrackerStore(context: context, categoryStore: trackerCategoryStore)
        let trackerRecordStore = TrackerRecordStore(context: context, trackerStore: trackerDataStore)
        
        self.trackerProvider = TrackerProvider(
            store: trackerDataStore,
            context: context
        )
        self.categoryProvider = TrackerCategoryProvider(
            store: trackerCategoryStore,
            context: context
        )
        self.recordProvider = TrackerRecordProvider(
            store: trackerRecordStore,
            context: context
        )
    }
    
}
