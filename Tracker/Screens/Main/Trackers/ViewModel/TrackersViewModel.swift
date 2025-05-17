//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 03.04.2025.
//

import Foundation

enum TrackersViewModelState {
    case content(update: TrackerStoreUpdate)
    case empty(update: TrackerStoreUpdate)
    case searchNotFound(update: TrackerStoreUpdate)
    
    var update: TrackerStoreUpdate {
        switch self {
        case .content(let update), .empty(let update), .searchNotFound(let update):
            return update
        }
    }
}

typealias State = TrackersViewModelState

protocol TrackersViewModelProtocol: AnyObject {
    
    var onStateChange: ((State) -> Void)? { get set }
    var currentFilter: Filter { get }
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func nameOfSection(at: IndexPath) -> String?
    func tracker(at: IndexPath) -> Tracker?
    func isTrackerCompleted(_ tracker: Tracker) -> Bool
    func completedDaysCount(for tracker: Tracker) -> Int
    func updateFilter(to filter: Filter)
    func filterTrackers(by date: Date)
    func searchTrackers(with query: String)
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool)
    
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((State) -> Void)?
    var currentFilter: Filter {
        filterOptions.filter
    }
    
    // MARK: - Private Properties
    
    private var dataManager: DataManagerProtocol
    private var searchDebounceTimer: Timer?
    private var filterOptions = TrackerFilterOptions(date: Date(), searchQuery: "", filter: .all)
    private var state: State = .empty(update: .init()) {
        didSet { onStateChange?(state) }
    }
    
    // MARK: - Initialization
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        
        self.dataManager.trackerProvider.delegate = self
        applyCurrentFilter()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRefreshNotification),
            name: .trackersShouldRefresh,
            object: nil
        )
    }
    
}

// MARK: - Internal Methods

extension TrackersViewModel {
    
    var numberOfSections: Int {
        dataManager.trackerProvider.numberOfSections
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        dataManager.trackerProvider.numberOfItemsInSection(section)
    }
    
    func nameOfSection(at indexPath: IndexPath) -> String? {
        dataManager.trackerProvider.nameOfSection(at: indexPath)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        dataManager.trackerProvider.tracker(at: indexPath)
    }
    
    func isTrackerCompleted(_ tracker: Tracker) -> Bool {
        dataManager.recordProvider.isTrackerCompleted(tracker.id, on: filterOptions.date)
    }
    
    func completedDaysCount(for tracker: Tracker) -> Int {
        dataManager.recordProvider.completedTrackersCount(for: tracker.id)
    }
    
    func updateFilter(to filter: Filter) {
        filterOptions.filter = filter
        applyCurrentFilter()
    }
    
    func filterTrackers(by date: Date) {
        filterOptions.date = date
        applyCurrentFilter()
    }
    
    func searchTrackers(with query: String) {
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(
            withTimeInterval: 0.3,
            repeats: false
        ) { [weak self] _ in
            self?.filterOptions.searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            self?.applyCurrentFilter()
        }
    }
    
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool) {
        let record = TrackerRecord(id: tracker.id, date: filterOptions.date)

        do {
            if isCompleted {
                try dataManager.recordProvider.addRecord(record)
            } else {
                try dataManager.recordProvider.deleteRecord(record)
            }
        } catch {
            print("Error updating record: \(error)")
        }
    }
    
}

// MARK: - Private Methods

private extension TrackersViewModel {
    
    func determineState(_ update: TrackerStoreUpdate) -> TrackersViewModelState {
        let hasData = dataManager.trackerProvider.numberOfSections > 0
        
        if hasData {
            return .content(update: update)
        } else {
            return filterOptions.searchQuery.isEmpty ?
                .empty(update: update) :
                .searchNotFound(update: update)
        }
    }
    
    func applyCurrentFilter() {
        dataManager.trackerProvider.applyFilter(with: filterOptions)
    }

    
    @objc func handleRefreshNotification() {
        applyCurrentFilter()
    }
    
}

// MARK: - TrackerDataProviderDelegate

extension TrackersViewModel: TrackerProviderDelegate {
    
    func didUpdate(_ update: TrackerStoreUpdate) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.state = self.determineState(update)
        }
    }
    
}
