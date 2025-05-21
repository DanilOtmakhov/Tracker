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
    func loadStatistics()
    var numberOfItems: Int { get }
    func item(at indexPath: IndexPath) -> StatisticItem
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
    }
    
}

// MARK: - Internal Methods

extension StatisticsViewModel {
    
    func loadStatistics() {
        statisticsService.recalculateStatistics()
        items = statisticsService.fetchStatistics()
        
        onStateChanged?(items.isEmpty ? .empty : .content)
    }
    
    var numberOfItems: Int {
        items.count
    }
    
    func item(at indexPath: IndexPath) -> StatisticItem {
        items[indexPath.row]
    }
    
}
