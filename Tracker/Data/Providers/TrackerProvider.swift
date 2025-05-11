//
//  TrackerProvider.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.04.2025.
//

import CoreData

struct TrackerStoreUpdate {
    
    var insertedSections: IndexSet
    var deletedSections: IndexSet
    var insertedIndexPaths: [IndexPath]
    var deletedIndexPaths: [IndexPath]
    var updatedIndexPaths: [IndexPath]
    var movedIndexPaths: [(from: IndexPath, to: IndexPath)]
    
    init(insertedSections: IndexSet = IndexSet(),
         deletedSections: IndexSet = IndexSet(),
         insertedIndexPaths: [IndexPath] = [],
         deletedIndexPaths: [IndexPath] = [],
         updatedIndexPaths: [IndexPath] = [],
         movedIndexPaths: [(from: IndexPath, to: IndexPath)] = []) {
        self.insertedSections = insertedSections
        self.deletedSections = deletedSections
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.updatedIndexPaths = updatedIndexPaths
        self.movedIndexPaths = movedIndexPaths
    }
    
    var isEmpty: Bool {
        insertedSections.isEmpty &&
        deletedSections.isEmpty &&
        insertedIndexPaths.isEmpty &&
        deletedIndexPaths.isEmpty &&
        updatedIndexPaths.isEmpty &&
        movedIndexPaths.isEmpty
    }
    
}

protocol TrackerProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

protocol TrackerProviderProtocol {
    var delegate: TrackerProviderDelegate? { get set }
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func nameOfSection(at: IndexPath) -> String?
    func tracker(at: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker, to: TrackerCategory) throws
    func applyFilter(currentDate: Date, searchQuery: String)
}

final class TrackerProvider: NSObject {
    
    weak var delegate: TrackerProviderDelegate?

    private let context: NSManagedObjectContext
    private let store: TrackerStoreProtocol
    private var pendingUpdate = TrackerStoreUpdate()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerEntity> = {

        let fetchRequest: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
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
        fetchedResultsController.sections?[indexPath.section].name
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let object = fetchedResultsController.object(at: indexPath)
        return Tracker.from(object)
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
            delegate?.didUpdate(TrackerStoreUpdate())
        } catch {
            print("Failed to fetch data after filtering: \(error)")
        }
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pendingUpdate = TrackerStoreUpdate()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(pendingUpdate)
        pendingUpdate = TrackerStoreUpdate()
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
                pendingUpdate.insertedIndexPaths.append(newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                pendingUpdate.deletedIndexPaths.append(indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                pendingUpdate.updatedIndexPaths.append(indexPath)
            }
        case .move:
            if let from = indexPath, let to = newIndexPath {
                if from.section != to.section {
                    pendingUpdate.deletedIndexPaths.append(from)
                    pendingUpdate.insertedIndexPaths.append(to)
                } else {
                    pendingUpdate.movedIndexPaths.append((from: from, to: to))
                }
            }
        @unknown default:
            break
        }
    }
    
}
