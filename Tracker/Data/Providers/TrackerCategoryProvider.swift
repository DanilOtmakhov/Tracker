//
//  TrackerCategoryProvider.swift
//  Tracker
//
//  Created by Danil Otmakhov on 22.04.2025.
//

import CoreData

struct TrackerCategoryStoreUpdate {
    
    var insertedIndexPaths: [IndexPath]
    var deletedIndexPaths: [IndexPath]
    var updatedIndexPaths: [IndexPath]
    var movedIndexPaths: [(from: IndexPath, to: IndexPath)]
    
    var isEmpty: Bool {
        insertedIndexPaths.isEmpty &&
        deletedIndexPaths.isEmpty &&
        updatedIndexPaths.isEmpty &&
        movedIndexPaths.isEmpty
    }
    
    init(
         insertedIndexPaths: [IndexPath] = [],
         deletedIndexPaths: [IndexPath] = [],
         updatedIndexPaths: [IndexPath] = [],
         movedIndexPaths: [(from: IndexPath, to: IndexPath)] = []
    ) {
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.updatedIndexPaths = updatedIndexPaths
        self.movedIndexPaths = movedIndexPaths
    }
    
}

protocol TrackerCategoryProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

protocol TrackerCategoryProviderProtocol {
    var delegate: TrackerCategoryProviderDelegate? { get set }
    func numberOfCategories() -> Int
    func numberOfRows(in section: Int) -> Int
    func category(at indexPath: IndexPath) -> TrackerCategory?
    func addCategory(withTitle title: String) throws
    func deleteCategory(at indexPath: IndexPath) throws
    func edit(_ category: TrackerCategory, withTitle title: String) throws
    func category(of tracker: Tracker) throws -> TrackerCategory?
}

final class TrackerCategoryProvider: NSObject {
    
    weak var delegate: TrackerCategoryProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let store: TrackerCategoryStoreProtocol
    private var pendingUpdate = TrackerCategoryStoreUpdate()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryEntity> = {

        let fetchRequest: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(
        store: TrackerCategoryStoreProtocol,
        context: NSManagedObjectContext
    ) {
        self.store = store
        self.context = context
    }
    
}

// MARK: - TrackerCategoryProviderProtocol

extension TrackerCategoryProvider: TrackerCategoryProviderProtocol {
    
    func numberOfCategories() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory? {
        let object = fetchedResultsController.object(at: indexPath)
        return TrackerCategory.from(object)
    }
    
    func addCategory(withTitle title: String) throws {
        try store.addCategory(withTitle: title)
    }
    
    func deleteCategory(at indexPath: IndexPath) throws {
        guard let category = category(at: indexPath) else { return }
        try store.delete(category)
    }
    
    func edit(_ category: TrackerCategory, withTitle title: String) throws {
        try store.edit(category, withTitle: title)
    }
    
    func category(of tracker: Tracker) throws -> TrackerCategory? {
        guard let categoryEntity = try store.category(of: tracker) else { return nil }
        return TrackerCategory.from(categoryEntity)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pendingUpdate = TrackerCategoryStoreUpdate()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(pendingUpdate)
        pendingUpdate = TrackerCategoryStoreUpdate()
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
