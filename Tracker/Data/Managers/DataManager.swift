//
//  DataManager.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import Foundation

protocol DataManagerProtocol {
    var trackerDataProvider: TrackerProviderProtocol { get set }
    var trackerCategoryDataProvider: TrackerCategoryProviderProtocol { get }
    var trackerRecordDataProvider: TrackerRecordProviderProtocol { get }
}

final class DataManager: DataManagerProtocol {
    
    var trackerDataProvider: TrackerProviderProtocol
    let trackerCategoryDataProvider: TrackerCategoryProviderProtocol
    let trackerRecordDataProvider: TrackerRecordProviderProtocol
    
    init() {
        let trackerCategoryStore = TrackerCategoryStore(context: CoreDataStack.shared.context)
        let trackerDataStore = TrackerStore(context: CoreDataStack.shared.context, categoryStore: trackerCategoryStore)
        let trackerRecordStore = TrackerRecordStore(context: CoreDataStack.shared.context, trackerStore: trackerDataStore)
        
        self.trackerDataProvider = TrackerProvider(
            store: trackerDataStore,
            context: CoreDataStack.shared.context
        )
        self.trackerCategoryDataProvider = TrackerCategoryProvider(
            store: trackerCategoryStore,
            context: CoreDataStack.shared.context
        )
        self.trackerRecordDataProvider = TrackerRecordProvider(
            store: trackerRecordStore,
            context: CoreDataStack.shared.context
        )
    }
    
}
