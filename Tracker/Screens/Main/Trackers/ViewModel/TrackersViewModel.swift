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
        filterTrackers(by: currentDate)
    }
    
    func filterTrackers(by date: Date) {
        currentDate = date
        
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)

        guard let currentDay = Day(rawValue: dayOfWeek) else { return }

        visibleCategories = categories.map { category /*-> TrackerCategory */in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return false }
                return schedule.contains(currentDay)
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }

        print(visibleCategories[0].trackers[0].title)
        
        state = visibleCategories.isEmpty ? .empty : .content(categories: visibleCategories)
    }
    
    func searchTrackers(with query: String) {
        
    }
    
    func handleCompleteButtonTap(_ tracker: Tracker, isCompleted: Bool) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        completedTrackers.insert(trackerRecord)
    }
    
}

// MARK: - Private Methods

private extension TrackersViewModel {
    
    func handleTrackerAdded() {
        categories = trackerStore.fetchTrackerCategories()
        state = .content(categories: categories)
    }
    
}
