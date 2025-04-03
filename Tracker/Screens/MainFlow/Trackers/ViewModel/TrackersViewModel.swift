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
    func loadTrackers()
    func filterTrackers(by date: Date)
    func searchTrackers(with query: String)
    
}

final class TrackersViewModel {
    
    // MARK: - Internal Properties
    
    var onStateChange: ((State) -> Void)?
    
    // MARK: - Private Properties
    
    private let store: TrackerStoreProtocol
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord]?
    private var currentDate: Date = Date()
    private var state: State = .empty {
        didSet {
            onStateChange?(state)
        }
    }
    
    // MARK: - Initialization
    
    init(store: TrackerStoreProtocol) {
        self.store = store
    }
    
}

// MARK: - TrackersViewModelProtocol

extension TrackersViewModel: TrackersViewModelProtocol {
    
    func loadTrackers() {
        categories = store.fetchTrackerCategories()
        state = .content(categories: categories)
    }
    
    func filterTrackers(by date: Date) {
        
    }
    
    func searchTrackers(with query: String) {
        
    }
    
}
