//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 03.04.2025.
//

import Foundation

enum TrackersViewModelState {
    case content(update: TrackersStoreUpdate)
    case empty(update: TrackersStoreUpdate)
    case searchNotFound(update: TrackersStoreUpdate)
    
    var update: TrackersStoreUpdate {
        switch self {
        case .content(let update), .empty(let update), .searchNotFound(let update):
            return update
        }
    }
}

typealias State = TrackersViewModelState

protocol TrackersViewModelProtocol {
    
    var onStateChange: ((State) -> Void)? { get set }
    var numberOfSections: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func nameOfSection(at: IndexPath) -> String?
    func tracker(at: IndexPath) -> Tracker?
    func isTrackerCompleted(_ tracker: Tracker) -> Bool
    func completedDaysCount(for tracker: Tracker) -> Int
    func filterTrackers(by date: Date)
    func searchTrackers(with query: String)
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool)
    
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((State) -> Void)?
    
    // MARK: - Private Properties
    
    private var dataManager: DataManagerProtocol
    
    private var searchDebounceTimer: Timer?
    private var currentDate: Date = Date()
    private var searchQuery: String = ""
    
    private var state: State = .empty(update: .init()) {
        didSet { onStateChange?(state) }
    }
    
    // MARK: - Initialization
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        
        self.dataManager.trackerProvider.delegate = self
        dataManager.trackerProvider.applyFilter(currentDate: currentDate, searchQuery: searchQuery)
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
        dataManager.recordProvider.isTrackerCompleted(tracker.id, on: currentDate)
    }
    
    func completedDaysCount(for tracker: Tracker) -> Int {
        dataManager.recordProvider.completedTrackersCount(for: tracker.id)
    }
    
    func filterTrackers(by date: Date) {
        currentDate = date
        dataManager.trackerProvider.applyFilter(currentDate: currentDate, searchQuery: searchQuery)
    }
    
    func searchTrackers(with query: String) {
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(
            withTimeInterval: 0.3,
            repeats: false
        ) { [weak self] _ in
            self?.searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            self?.dataManager.trackerProvider.applyFilter(currentDate: self?.currentDate ?? Date(), searchQuery: self?.searchQuery ?? "")
        }
    }
    
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool) {
        let record = TrackerRecord(id: tracker.id, date: currentDate)

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
    
    func determineState(_ update: TrackersStoreUpdate) -> TrackersViewModelState {
        let hasData = dataManager.trackerProvider.numberOfSections > 0
        
        if hasData {
            return .content(update: update)
        } else {
            return searchQuery.isEmpty ?
                .empty(update: update) :
                .searchNotFound(update: update)
        }
    }
    
}

// MARK: - TrackerDataProviderDelegate

extension TrackersViewModel: TrackerProviderDelegate {
    
    func didUpdate(_ update: TrackersStoreUpdate) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.state = self.determineState(update)
        }
    }
    
}
