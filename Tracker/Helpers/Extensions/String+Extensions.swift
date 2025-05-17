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
    static let irregularEvent = "irregularEvent".localized
    static let habitNew = "habit.new".localized
    static let irregularEventNew = "irregularEvent.new".localized

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
    static let characterLimit = "characterLimit".localized
    static let filters = "filters".localized

    // MARK: - Actions

    static let done = "done".localized
    static let create = "create".localized
    static let cancel = "cancel".localized
    static let edit = "edit".localized
    static let delete = "delete".localized
    static let deleteConfirmation = "delete.confirmation".localized

    // MARK: - Pluralization

    static let daysCount = "days.count"
    
}

