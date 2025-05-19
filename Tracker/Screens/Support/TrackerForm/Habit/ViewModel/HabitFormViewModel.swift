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
    func selectDays(_ days: [Day])
    
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

//    override var trackerToEdit: Tracker?
//    {
//        didSet {
//            guard
//                let trackerToEdit,
//                let schedule = trackerToEdit.schedule
//            else { return }
//            title = trackerToEdit.title
//            selectedCategory = try? dataManager.categoryProvider.category(of: trackerToEdit)
//            selectedColor = trackerToEdit.color
//            selectedEmoji = trackerToEdit.emoji
//            selectedDays = schedule
//        }
//    }
    
    override var isFormValid: Bool {
        guard
            let title,
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
    
    override init(dataManager: DataManagerProtocol, trackerToEdit: Tracker? = nil) {
        super.init(dataManager: dataManager, trackerToEdit: trackerToEdit)
        
        if let tracker = trackerToEdit {
            guard let days = tracker.schedule else { return }
            selectedDays = days
        }
    }
    
    func selectDays(_ days: [Day]) {
        selectedDays = days
    }
    
    override func completeForm() {
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
        
        
        try? dataManager.trackerProvider.addTracker(tracker, to: selectedCategory)
    }
    
}
