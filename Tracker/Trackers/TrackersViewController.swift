//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var datePicker: UIDatePicker = {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        return $0
    }(UIDatePicker())
    
    private lazy var stubImageView: UIImageView = {
        $0.image = UIImage(named: "stub")
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var stubLabel: UILabel = {
        $0.text = "Что будем отслеживать?"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var searchController: UISearchController = {
        $0.searchBar.placeholder = "Поиск"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.tintColor = .ypGray
        $0.searchResultsUpdater = self
        return $0
    }(UISearchController())
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
}

// MARK: - Private Methods

private extension TrackersViewController {
    
    func setupViewController() {
        view.backgroundColor = .ypWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.searchController = searchController
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        [stubImageView, stubLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
    
}

// MARK: - Actions

private extension TrackersViewController {
    
    @objc func addButtonTapped() {
        
    }
    
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
