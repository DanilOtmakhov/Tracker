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
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: - Internal Properties
    
    var onStateChanged: ((StatisticsState) -> Void)?
    
    // MARK: - Private Properties
    
    private let statistics: [StatisticItem] = [
        StatisticItem(value: 6, title: .bestPeriod),
        StatisticItem(value: 2, title: .perfectDays),
        StatisticItem(value: 5, title: .trackersCompleted),
        StatisticItem(value: 4, title: .averageValue)
    ]
    
    private var state: StatisticsState = .empty {
        didSet {
            onStateChanged?(state)
        }
    }
    
    var numberOfItems: Int {
        statistics.count
    }
    
    func item(at indexPath: IndexPath) -> StatisticItem {
        statistics[indexPath.row]
    }
    
}
