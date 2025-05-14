//
//  String+Extensions.swift
//  Tracker
//
//  Created by Danil Otmakhov on 15.05.2025.
//

import Foundation

extension String {
    // MARK: - Onboarding
    /// "Track only what you want" (onboarding blue text)
    static let onboardingBlue = NSLocalizedString("onboarding.blue", comment: "Track only what you want")
    
    /// "Even if it’s not liters of water or yoga" (onboarding red text)
    static let onboardingRed = NSLocalizedString("onboarding.red", comment: "Even if it’s not liters of water or yoga")
    
    /// "Now that’s technology!" (onboarding button)
    static let onboardingButton = NSLocalizedString("onboarding.button", comment: "Now that’s technology!")
    
    // MARK: - Main Tabs
    /// "Trackers" (main tab title)
    static let trackers = NSLocalizedString("trackers", comment: "Trackers")
    
    /// "Statistics" (main tab title)
    static let statistics = NSLocalizedString("statistics", comment: "Statistics")
    
    // MARK: - Tracker Creation
    /// "Create Tracker" (screen title)
    static let trackerCreation = NSLocalizedString("trackerCreation", comment: "Create Tracker")
    
    // MARK: - Tracker Types
    /// "Habit" (button)
    static let habit = NSLocalizedString("habit", comment: "Habit")
    
    /// "Irregular Event" (button)
    static let irregularEvent = NSLocalizedString("irregularEvent", comment: "Irregular Event")
    
    /// "New Habit" (screen title)
    static let habitNew = NSLocalizedString("habit.new", comment: "New Habit")
    
    /// "New Irregular Event"  (screen title)
    static let irregularEventNew = NSLocalizedString("irregularEvent.new", comment: "New Irregular Event")
    
    // MARK: - Category
    /// "Category" (screen title/section title)
    static let category = NSLocalizedString("category", comment: "Category")
    
    /// "New Category"  (screen title)
    static let categoryNew = NSLocalizedString("category.new", comment: "New Category")
    
    /// "Edit Category" (screen title)
    static let categoryEdit = NSLocalizedString("category.edit", comment: "Edit Category")
    
    // MARK: - Input Fields
    /// "Enter tracker name" (text field placeholder)
    static let enteringTrackerName = NSLocalizedString("enteringTrackerName", comment: "Enter tracker name")
    
    /// "Schedule" (section title for habit scheduling)
    static let schedule = NSLocalizedString("schedule", comment: "Schedule")
    
    /// "Emoji" (section title for emoji selection)
    static let emoji = NSLocalizedString("emoji", comment: "Emoji")
    
    /// "Color" (section title for color selection)
    static let color = NSLocalizedString("color", comment: "Color")
    
    /// "Enter category name" (text field placeholder)
    static let enteringCategoryName = NSLocalizedString("enteringCategoryName", comment: "Enter category name")
    
    /// "Add Category" (button action)
    static let addCategory = NSLocalizedString("addCategory", comment: "Add Category")
    
    // MARK: - UI States
    /// "Search" (search bar placeholder)
    static let search = NSLocalizedString("search", comment: "Search")
    
    /// "What would you like to track?" (empty state for trackers)
    static let trackersEmptyState = NSLocalizedString("trackers.emptyState", comment: "What would you like to track?")
    
    /// "Habits and events can be grouped by meaning" (empty state for categories)
    static let categoriesEmptyState = NSLocalizedString("categories.emptyState", comment: "Habits and events can be grouped by meaning")
    
    /// "Nothing found" (search/no results)
    static let nothingFound = NSLocalizedString("nothingFound", comment: "Nothing found")
    
    /// "Character limit" (text)
    static let characterLimit = NSLocalizedString("characterLimit", comment: "Character limit")
    
    // MARK: - Actions
    /// "Done" (confirmation action)
    static let done = NSLocalizedString("done", comment: "Done")
    
    /// "Create" (confirmation action)
    static let create = NSLocalizedString("create", comment: "Create")
    
    /// "Cancel" (dismiss action)
    static let cancel = NSLocalizedString("cancel", comment: "Cancel")
    
    /// "Edit" (modification action)
    static let edit = NSLocalizedString("edit", comment: "Edit")
    
    /// "Delete" (destructive action)
    static let delete = NSLocalizedString("delete", comment: "Delete")
    
    /// "Are you sure you want to delete the tracker?" (confirmation alert)
    static let deleteConfirmation = NSLocalizedString("delete.confirmation", comment: "Are you sure you want to delete the tracker?")
}
