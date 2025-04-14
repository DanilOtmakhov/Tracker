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
        guard let title,
                !title.isEmpty,
              selectedCategory != nil,
              selectedEmoji != nil,
              selectedColor != nil,
              !selectedDays.isEmpty
        else {
            return false
        }
        
        return true
    }
    
    func didSelectDays(_ days: [Day]) {
        selectedDays = days
    }
    
    override func createTracker() {
        guard let title,
              let selectedCategory,
              let selectedEmoji,
              let selectedColor
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            title: title,
            emoji: selectedEmoji,
            color: selectedColor,
            schedule: selectedDays
        )
        
        let category = TrackerCategory(title: selectedCategory, trackers: [tracker])
        
        trackerStore.addTracker(category)
    }
    
}
