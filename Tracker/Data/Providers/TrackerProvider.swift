//
//  TrackerProvider.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.04.2025.
//

import CoreData

struct TrackersStoreUpdate {
    
    var insertedSections: IndexSet
    var deletedSections: IndexSet
    var inserted: [IndexPath]
    var deleted: [IndexPath]
    var updated: [IndexPath]
    var moved: [(from: IndexPath, to: IndexPath)]
    
    init(insertedSections: IndexSet = IndexSet(),
         deletedSections: IndexSet = IndexSet(),
         inserted: [IndexPath] = [],
         deleted: [IndexPath] = [],
         updated: [IndexPath] = [],
         moved: [(from: IndexPath, to: IndexPath)] = []) {
        self.insertedSections = insertedSections
        self.deletedSections = deletedSections
        self.inserted = inserted
        self.deleted = deleted
        self.updated = updated
        self.moved = moved
    }
    
    var isEmpty: Bool {
        self.insertedSections.isEmpty &&
        self.deletedSections.isEmpty &&
        self.inserted.isEmpty &&
        self.deleted.isEmpty &&
        self.updated.isEmpty &&
        self.moved.isEmpty
    }
    
}

protocol TrackerProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackersStoreUpdate)
}

protocol TrackerProviderProtocol {
    var delegate: TrackerProviderDelegate? { get set }
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func nameOfSection(at: IndexPath) -> String?
    func tracker(at: IndexPath) -> Tracker?
    func indexPath(for: Tracker) -> IndexPath?
    func addTracker(_ tracker: Tracker, to: TrackerCategory) throws
    func applyFilter(currentDate: Date, searchQuery: String)
}

final class TrackerProvider: NSObject {
    
    weak var delegate: TrackerProviderDelegate?

    private let context: NSManagedObjectContext
    private let store: TrackerStoreProtocol
    private var pendingUpdate = TrackersStoreUpdate(inserted: [], deleted: [], updated: [], moved: [])

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerEntity> = {

        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category.title", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "category.title",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(
        store: TrackerStoreProtocol,
        context: NSManagedObjectContext = CoreDataStack.shared.context
    ) {
        self.context = context
        self.store = store
    }
    
}

// MARK: - TrackerDataProviderProtocol

extension TrackerProvider: TrackerProviderProtocol {
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func nameOfSection(at indexPath: IndexPath) -> String? {
        guard let section = fetchedResultsController.sections?[indexPath.section] else {
            return nil
        }
        return section.name
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let object = fetchedResultsController.object(at: indexPath)
        return Tracker.from(object)
    }
    
    func indexPath(for tracker: Tracker) -> IndexPath? {
        let request = fetchedResultsController.fetchRequest
        let originalPredicate = request.predicate
        
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        defer { request.predicate = originalPredicate } 
        
        do {
            let results = try fetchedResultsController.managedObjectContext.fetch(request)
            guard let entity = results.first else { return nil }
            return fetchedResultsController.indexPath(forObject: entity)
        } catch {
            print("Failed to fetch tracker index path: \(error)")
            return nil
        }
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        try store.add(tracker, to: category)
    }
    
    func applyFilter(currentDate: Date, searchQuery: String) {
        var predicates: [NSPredicate] = []
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let currentDay = Day(rawValue: weekday) else { return }
        
        let startOfDay = calendar.startOfDay(for: currentDate)
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let scheduledPredicate = NSPredicate(format: "schedule != nil AND schedule CONTAINS %@", "\(currentDay.rawValue)")

        let oneTimeNeverCompleted = NSPredicate(format: "schedule == nil AND records.@count == 0")
        let oneTimeCompletedToday = NSPredicate(
            format: "schedule == nil AND SUBQUERY(records, $r, $r.date >= %@ AND $r.date < %@).@count > 0",
            startOfDay as NSDate,
            startOfNextDay as NSDate
        )
        
        let oneTimePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            oneTimeNeverCompleted,
            oneTimeCompletedToday
        ])
        
        let displayPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            scheduledPredicate,
            oneTimePredicate
        ])
        
        predicates.append(displayPredicate)
        
        if !searchQuery.isEmpty {
            let searchPredicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR emoji CONTAINS[cd] %@",
                searchQuery, searchQuery
            )
            predicates.append(searchPredicate)
        }

        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            try fetchedResultsController.performFetch()
            delegate?.didUpdate(TrackersStoreUpdate())
        } catch {
            print("Failed to fetch data after filtering: \(error)")
        }
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pendingUpdate = TrackersStoreUpdate()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(pendingUpdate)
        pendingUpdate = TrackersStoreUpdate()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange sectionInfo: NSFetchedResultsSectionInfo,
                   atSectionIndex sectionIndex: Int,
                   for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            pendingUpdate.insertedSections.insert(sectionIndex)
        case .delete:
            pendingUpdate.deletedSections.insert(sectionIndex)
        default:
            break
        }
    }

    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                pendingUpdate.inserted.append(newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                pendingUpdate.deleted.append(indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                pendingUpdate.updated.append(indexPath)
            }
        case .move:
            if let from = indexPath, let to = newIndexPath {
                if from.section != to.section {
                    pendingUpdate.deleted.append(from)
                    pendingUpdate.inserted.append(to)
                } else {
                    pendingUpdate.moved.append((from: from, to: to))
                }
            }
        @unknown default:
            break
        }
    }
    
}
