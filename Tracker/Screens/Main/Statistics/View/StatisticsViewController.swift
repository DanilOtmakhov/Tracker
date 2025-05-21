//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let tableViewHorizontalInset: CGFloat = 16
        static let rowHeight: CGFloat = 102
        
        static let stubImageSize: CGFloat = 80
        static let stubImageTopOffset: CGFloat = -31
        
        static let stubLabelTopOffset: CGFloat = 8
    }
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.reuseIdentifier)
        return $0
    }(UITableView())
    
    private lazy var stubImageView: UIImageView = {
        $0.image = UIImage(resource: .nothingToAnalyze)
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    private lazy var stubLabel: UILabel = {
        $0.text = .nothingToAnalyze
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())
    
    // MARK: - Private Properties
    
    private var viewModel: StatisticsViewModelProtocol
    
    // MARK: - Initialization
    
    init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadStatistics()
    }
    
}

// MARK: - Private Methods

private extension StatisticsViewController {
    
    func setupViewController() {
        view.backgroundColor = .ypWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = .statistics
        
        [tableView, stubImageView, stubLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: Constants.rowHeight * CGFloat(viewModel.numberOfItems)),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableViewHorizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableViewHorizontalInset),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.stubImageTopOffset),
            stubImageView.heightAnchor.constraint(equalToConstant: Constants.stubImageSize),
            stubImageView.widthAnchor.constraint(equalToConstant: Constants.stubImageSize),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: Constants.stubLabelTopOffset),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .content:
                self?.hideStubView()
            case .empty:
                self?.showStubView()
            }
        }
    }
    
    func showStubView() {
        tableView.isHidden = true
        stubImageView.isHidden = false
        stubLabel.isHidden = false
    }
    
    func hideStubView() {
        stubImageView.isHidden = true
        stubLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticCell
        else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath)
        cell.configure(value: item.value, title: item.title)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
}
