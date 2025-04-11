//
//  HabitFormViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 10.04.2025.
//

import Foundation

protocol HabitFormViewModelProtocol: TrackerFormViewModelProtocol {
    
    var selectedDays: [Day] { get set }
    var selectedDaysString: String? { get }
    func didSelectDays(_ days: [Day])
    
}

final class HabitFormViewModel: TrackerFormViewModel, HabitFormViewModelProtocol {

    var selectedDays: [Day] = [] {
        didSet {
            onFormUpdated?()
        }
    }
    
    var selectedDaysString: String? {
        guard !selectedDays.isEmpty else { return nil }
        if Set(selectedDays) == Set(Day.allCases) { return "Каждый день" }
        return selectedDays.map { $0.shortString }.joined(separator: ", ")
    }

    
    override var isFormValid: Bool {
        guard let title, !title.isEmpty else { return false }
        guard selectedCategory != nil else { return false }
        guard !selectedDays.isEmpty else { return false }
        return true
    }
    
    func didSelectDays(_ days: [Day]) {
        selectedDays = days
    }
    
    override func createTracker() {
        guard let title,
              let selectedCategory
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            title: title,
            emoji: "😊",
            color: .color4,
            schedule: selectedDays
        )
        
        print("created")
    }
    
}
