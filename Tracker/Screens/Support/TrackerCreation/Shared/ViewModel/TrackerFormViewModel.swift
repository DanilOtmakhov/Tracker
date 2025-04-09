//
//  TrackerFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import Foundation

protocol TrackerFormViewModelProtocol {
    

    
}

class TrackerFormViewModel: TrackerFormViewModelProtocol {
    
    private let trackerStore: TrackerStoreProtocol
    
    init(trackerStore: TrackerStoreProtocol) {
        self.trackerStore = trackerStore
        
    }
    
}
