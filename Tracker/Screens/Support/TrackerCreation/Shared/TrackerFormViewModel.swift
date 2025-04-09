//
//  TrackerFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import Foundation

protocol TrackerFormViewModelProtocol {
    
    var selectedDays: [Day] { get set }
    func updateSelectedDays(_ days: [Day])
    
}

class TrackerFormViewModel: TrackerFormViewModelProtocol {
    
    var selectedDays: [Day] = [] {
        didSet {
            // UI
        }
    }
    
    func updateSelectedDays(_ days: [Day]) {
        selectedDays = days
    }
    
}
