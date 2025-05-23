//
//  String+Extensions.swift
//  Tracker
//
//  Created by Danil Otmakhov on 15.05.2025.
//

import Foundation

extension String {
    
    // MARK: - Helpers
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localizedFormat(_ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, locale: .current, arguments: arguments)
    }

    func localizedPluralized(count: Int) -> String {
        String.localizedStringWithFormat(NSLocalizedString(self, comment: ""), count)
    }

    // MARK: - Onboarding

    static let onboardingBlue = "onboarding.blue".localized
    static let onboardingRed = "onboarding.red".localized
    static let onboardingButton = "onboarding.button".localized

    // MARK: - Main Tabs

    static let trackers = "trackers".localized
    static let statistics = "statistics".localized

    // MARK: - Tracker Creation

    static let trackerCreation = "trackerCreation".localized

    // MARK: - Tracker Types

    static let habit = "habit".localized
    static let habitNew = "habit.new".localized
    static let habitEdit = "habit.edit".localized
    
    static let irregularEvent = "irregularEvent".localized
    static let irregularEventNew = "irregularEvent.new".localized
    static let irregularEventEdit = "irregularEvent.edit".localized

    // MARK: - Category

    static let category = "category".localized
    static let categoryNew = "category.new".localized
    static let categoryEdit = "category.edit".localized

    // MARK: - Input Fields

    static let enteringTrackerName = "enteringTrackerName".localized
    static let schedule = "schedule".localized
    static let emoji = "emoji".localized
    static let color = "color".localized
    static let enteringCategoryName = "enteringCategoryName".localized
    static let addCategory = "addCategory".localized

    // MARK: - UI States

    static let search = "search".localized
    static let trackersEmptyState = "trackers.emptyState".localized
    static let categoriesEmptyState = "categories.emptyState".localized
    static let nothingFound = "nothingFound".localized
    static let nothingToAnalyze = "nothingToAnalyze".localized
    static let characterLimit = "characterLimit".localized
    static let filters = "filters".localized
    
    // MARK: - Days
    
    static let monday = "monday".localized
    static let tuesday = "tuesday".localized
    static let wednesday = "wednesday".localized
    static let thursday = "thursday".localized
    static let friday = "friday".localized
    static let saturday = "saturday".localized
    static let sunday = "sunday".localized
    
    static let mondayShort = "monday.short".localized
    static let tuesdayShort = "tuesday.short".localized
    static let wednesdayShort = "wednesday.short".localized
    static let thursdayShort = "thursday.short".localized
    static let fridayShort = "friday.short".localized
    static let saturdayShort = "saturday.short".localized
    static let sundayShort = "sunday.short".localized
    
    static let everyDay = "everyDay".localized
    
    // MARK: - Filters
    
    static let allTrackers = "allTrackers".localized
    static let todayTrackers = "todayTrackers".localized
    static let completed = "completed".localized
    static let notCompleted = "notCompleted".localized
    static let pinned = "pinned".localized
    
    // MARK: - Statistics
    
    static let bestPeriod = "bestPeriod".localized
    static let perfectDays = "perfectDays".localized
    static let trackersCompleted = "trackersCompleted".localized
    static let averageValue = "averageValue".localized

    // MARK: - Actions

    static let done = "done".localized
    static let create = "create".localized
    static let save = "save".localized
    static let cancel = "cancel".localized
    static let pin = "pin".localized
    static let unpin = "unpin".localized
    static let edit = "edit".localized
    static let delete = "delete".localized
    static let deleteTrackerConfirmation = "delete.confirmation.tracker".localized
    static let deleteCategoryConfirmation = "delete.confirmation.category".localized

    // MARK: - Pluralization

    static let daysCount = "days.count"
    
}

