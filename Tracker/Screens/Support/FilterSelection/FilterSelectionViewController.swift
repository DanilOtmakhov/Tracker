//
//  FilterSelectionViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 18.05.2025.
//

import UIKit

enum TrackerFilterType: Int, CaseIterable {
    case all
    case today
    case completed
    case notCompleted
    
    var title: String {
        switch self {
        case .all: return .allTrackers
        case .today: return .todayTrackers
        case .completed: return .completed
        case .notCompleted: return .notCompleted
        }
    }
}

typealias Filter = TrackerFilterType

final class FilterSelectionViewController: UITableViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let rowHeight: CGFloat = 75
        static let separatorInset: CGFloat = 16
    }
    
    // MARK: - Internal Properties
    
    var onFilterSelected: ((Filter) -> Void)?
    
    // MARK: - Private Properties
    
    private var selectedFilter: Filter
    
    // MARK: - Initialization
    
    init(selectedFilter: Filter = .all) {
        self.selectedFilter = selectedFilter
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
    }

}

// MARK: - Private Methods

private extension FilterSelectionViewController {
    
    func setupViewController() {
        title = .filters
        view.backgroundColor = .ypWhite
    }
    
    func setupTableView() {
        tableView.backgroundColor = .ypWhite
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.register(FilterCell.self,
                    forCellReuseIdentifier: FilterCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Constants.separatorInset, bottom: 0, right: Constants.separatorInset)
    }
    
}

// MARK: - Data Source

extension FilterSelectionViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Filter.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let filter = Filter(rawValue: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: filter.title)
        
        if selectedFilter == filter {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
}

// MARK: - Delegate

extension FilterSelectionViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onFilterSelected?(Filter.allCases[indexPath.row])
    }
    
}
