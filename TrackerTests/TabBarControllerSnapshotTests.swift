//
//  TabBarControllerSnapshotTests.swift
//  TabBarControllerSnapshotTests
//
//  Created by Danil Otmakhov on 18.05.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class DummyTrackerProvider: TrackerProviderProtocol {
    weak var delegate: TrackerProviderDelegate?
    var numberOfSections: Int { 0 }
    func numberOfItemsInSection(_ section: Int) -> Int { 0 }
    func nameOfSection(at indexPath: IndexPath) -> String? { nil }
    func tracker(at indexPath: IndexPath) -> Tracker? { nil }
    func addTracker(_ tracker: Tracker, to: TrackerCategory) throws {}
    func editTracker(_ tracker: Tracker, to newTracker: Tracker, newCategory: TrackerCategory) throws {}
    func deleteTracker(at indexPath: IndexPath) throws {}
    func togglePin(at indexPath: IndexPath) throws {}
    func applyFilter(with options: TrackerFilterOptions) {}
    func fetchTrackerIDs(for date: Date) throws -> Set<UUID> { Set() }
}

final class DummyTrackerCategoryProvider: TrackerCategoryProviderProtocol {
    var delegate: TrackerCategoryProviderDelegate?
    func numberOfCategories() -> Int { 0 }
    func numberOfRows(in section: Int) -> Int { 0 }
    func category(at indexPath: IndexPath) -> TrackerCategory? { nil }
    func addCategory(withTitle title: String) throws {}
    func deleteCategory(at indexPath: IndexPath) throws {}
    func edit(_ category: TrackerCategory, withTitle title: String) throws {}
    func category(of tracker: Tracker) throws -> TrackerCategory? { nil }
}

final class DummyTrackerRecordProvider: TrackerRecordProviderProtocol {
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool { false }
    func completedDaysCount(for trackerID: UUID) -> Int { 0 }
    func addRecord(_ record: TrackerRecord) throws {}
    func deleteRecord(_ record: TrackerRecord) throws {}
    func completedTrackersCount() throws -> Int { 0 }
    func fetchAllCompletionDates() throws -> [Date] { [] }
    func fetchCompletionsGroupedByDate() throws -> [Date : Set<UUID>] { [:] }
}

final class DummyDataManager: DataManagerProtocol {
    var trackerProvider: TrackerProviderProtocol = DummyTrackerProvider()
    var categoryProvider: TrackerCategoryProviderProtocol = DummyTrackerCategoryProvider()
    var recordProvider: TrackerRecordProviderProtocol = DummyTrackerRecordProvider()
}

final class DummyStatisticsService: StatisticsServiceProtocol {
    func recalculateStatistics() {}
    func fetchStatistics() -> [StatisticItem] { [] }
}

final class TabBarControllerSnapshotTests: XCTestCase {

    func testTabBarControllerLightMode() {
        let dummyDataManager = DummyDataManager()
        let trackersViewModel = TrackersViewModel(dataManager: dummyDataManager)
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        
        trackersViewModel.onStateChange?(.empty(update: TrackerStoreUpdate()))
        
        let dummyStatisticService = DummyStatisticsService()
        let statisticsViewModel = StatisticsViewModel(statisticsService: dummyStatisticService)
        let statisticsViewController = StatisticsViewController(viewModel: statisticsViewModel)
        
        statisticsViewModel.onStateChanged?(.empty)
        
        let tabBarController = TabBarController(
            trackersViewController: UINavigationController(rootViewController: trackersViewController),
            statisticsViewController: UINavigationController(rootViewController: statisticsViewController)
        )
        
        tabBarController.overrideUserInterfaceStyle = .light
        tabBarController.view.frame = UIScreen.main.bounds
        tabBarController.loadViewIfNeeded()
        
        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .light)), named: "TabBar_LightMode")
    }
    
    func testTabBarControllerDarkMode() {
        let dummyDataManager = DummyDataManager()
        let trackersViewModel = TrackersViewModel(dataManager: dummyDataManager)
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        
        trackersViewModel.onStateChange?(.empty(update: TrackerStoreUpdate()))
        
        let dummyStatisticService = DummyStatisticsService()
        let statisticsViewModel = StatisticsViewModel(statisticsService: dummyStatisticService)
        let statisticsViewController = StatisticsViewController(viewModel: statisticsViewModel)
        
        statisticsViewModel.onStateChanged?(.empty)

        let tabBarController = TabBarController(
            trackersViewController: UINavigationController(rootViewController: trackersViewController),
            statisticsViewController: UINavigationController(rootViewController: statisticsViewController)
        )

        tabBarController.overrideUserInterfaceStyle = .dark
        tabBarController.view.frame = UIScreen.main.bounds
        tabBarController.loadViewIfNeeded()

        assertSnapshot(matching: tabBarController, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "TabBar_DarkMode")
    }

}
