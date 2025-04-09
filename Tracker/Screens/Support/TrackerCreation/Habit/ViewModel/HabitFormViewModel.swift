//
//  HabitFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 10.04.2025.
//

import Foundation

protocol HabitFormViewModelProtocol: TrackerFormViewModelProtocol {
    
    var selectedDays: [Day] { get set }
    func updateSelectedDays(_ days: [Day])
    
}

final class HabitFormViewModel: TrackerFormViewModel, HabitFormViewModelProtocol {
    
    var selectedDays: [Day] = [] {
        didSet {
            // UI
        }
    }
    
    func updateSelectedDays(_ days: [Day]) {
        selectedDays = days
    }
    
}
