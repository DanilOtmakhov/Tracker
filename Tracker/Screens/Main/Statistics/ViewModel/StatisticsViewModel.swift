//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Danil Otmakhov on 20.05.2025.
//

import Foundation

struct StatisticItem {
    let value: Int
    let title: String
}

enum StatisticsViewModelState {
    case empty
    case content
}

typealias StatisticsState = StatisticsViewModelState

protocol StatisticsViewModelProtocol {
    var onStateChanged: ((StatisticsState) -> Void)? { get set }
    var numberOfItems: Int { get }
    func item(at indexPath: IndexPath) -> StatisticItem
    func loadStatistics()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChanged: ((StatisticsState) -> Void)?
    
    // MARK: - Private Properties
    
    private let statisticsService: StatisticsService
    private var items: [StatisticItem] = []
    
    private var state: StatisticsState = .empty {
        didSet {
            onStateChanged?(state)
        }
    }
    
    // MARK: - Initialization
    
    init(statisticsService: StatisticsService) {
        self.statisticsService = statisticsService
        loadStatistics()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCompleteNotification),
            name: .statisticsShouldRefresh,
            object: nil
        )
    }
    
}

// MARK: - Internal Methods

extension StatisticsViewModel {
    
    var numberOfItems: Int {
        items.count
    }
    
    func item(at indexPath: IndexPath) -> StatisticItem {
        items[indexPath.row]
    }
    
    func loadStatistics() {
        statisticsService.recalculateStatistics()
        items = statisticsService.fetchStatistics()
        
        let allValuesAreZero = items.allSatisfy { $0.value == 0 }
        state = allValuesAreZero ? .empty : .content
    }
    
}

// MARK: - Actions

@objc
private extension StatisticsViewModel {
    
    func handleCompleteNotification() {
        loadStatistics()
    }
    
}
