//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 03.04.2025.
//

import Foundation

enum TrackersViewModelState {
    
    case content(categories: [TrackerCategory])
    case empty
    case searchNotFound
    
}

typealias State = TrackersViewModelState

protocol TrackersViewModelProtocol {
    
    var onStateChange: ((State) -> Void)? { get set }
    func isTrackerCompleted(_ tracker: Tracker) -> Bool
    func completedDaysCount(for tracker: Tracker) -> Int
    func loadTrackers()
    func filterTrackers(by date: Date)
    func searchTrackers(with query: String)
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool)
    
}

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((State) -> Void)?
    
    // MARK: - Private Properties
    
    private var trackerStore: TrackerStoreProtocol
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var searchQuery: String = ""
    private var state: State = .empty {
        didSet {
            onStateChange?(state)
        }
    }
    
    // MARK: - Initialization
    
    init(trackerStore: TrackerStoreProtocol) {
        self.trackerStore = trackerStore
        
        self.trackerStore.onTrackerAdded = { [weak self] in
            self?.handleTrackerAdded()
        }
    }
    
}

// MARK: - Internal Methods

extension TrackersViewModel {
    
    func isTrackerCompleted(_ tracker: Tracker) -> Bool {
        completedTrackers.contains { $0.id == tracker.id && $0.date == currentDate }
    }
    
    func completedDaysCount(for tracker: Tracker) -> Int {
        completedTrackers.filter { $0.id == tracker.id }.count
    }
    
    func loadTrackers() {
        categories = trackerStore.fetchTrackerCategories()
        completedTrackers = trackerStore.fetchCompletedTrackers()
        applyFilters()
    }
    
    func filterTrackers(by date: Date) {
        currentDate = date
        applyFilters()
    }
    
    func searchTrackers(with query: String) {
        searchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        applyFilters()
    }
    
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)

        if isCompleted {
            completedTrackers.insert(trackerRecord)
        } else {
            completedTrackers.remove(trackerRecord)
        }
    }
    
}

// MARK: - Private Methods

private extension TrackersViewModel {
    
    func handleTrackerAdded() {
        categories = trackerStore.fetchTrackerCategories()
        applyFilters()
    }
    
    func applyFilters() {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        
        guard let currentDay = Day(rawValue: dayOfWeek) else { return }
        
        visibleCategories = categories.map { category in
            let filteredTrackersByDate = category.trackers.filter { tracker in
                if let schedule = tracker.schedule {
                    return schedule.contains(currentDay)
                }
                
                if let completedRecord = completedTrackers.first(where: { $0.id == tracker.id }) {
                    return completedRecord.date == currentDate
                }
                
                return true
            }

            let filteredTrackersBySearch: [Tracker]
            if searchQuery.isEmpty {
                filteredTrackersBySearch = filteredTrackersByDate
            } else {
                filteredTrackersBySearch = filteredTrackersByDate.filter {
                    return $0.title.lowercased().contains(searchQuery) || $0.emoji.lowercased().contains(searchQuery)
                }
            }
            
            return TrackerCategory(title: category.title, trackers: filteredTrackersBySearch)
        }.filter { !$0.trackers.isEmpty }
 
        state = visibleCategories.isEmpty ? (searchQuery.isEmpty ? .empty : .searchNotFound) : .content(categories: visibleCategories)
    }
    
}
