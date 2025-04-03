//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var datePicker: UIDatePicker = {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.maximumDate = Date()
        $0.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    private lazy var stubImageView: UIImageView = {
        $0.image = UIImage(named: "stub")
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    private lazy var stubLabel: UILabel = {
        $0.text = "Что будем отслеживать?"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var searchController: UISearchController = {
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "Поиск"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.tintColor = .ypGray
        return $0
    }(UISearchController())
    
    private lazy var collectionView: UICollectionView = {
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        $0.register(TrackersHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersHeaderView.reuseIdentifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    // MARK: - Private Properties
    
    private var viewModel: TrackersViewModelProtocol
    private var categories: [TrackerCategory] = []
    
    // MARK: - Initialization
    
    init(viewModel: TrackersViewModelProtocol) {
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
        viewModel.loadTrackers()
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
        
        [collectionView, stubImageView, stubLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 110),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .content(let categories):
                self.stubImageView.isHidden = true
                self.stubLabel.isHidden = true
                self.collectionView.isHidden = false
                self.categories = categories
                self.collectionView.reloadData()
            case .empty:
                self.stubImageView.isHidden = false
                self.stubLabel.isHidden = false
                self.collectionView.isHidden = true
            case .searchNotFound:
                break
            }
        }
    }
    
}

// MARK: - Actions

@objc
private extension TrackersViewController {
    
    func addButtonTapped() {
        
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.filterTrackers(by: sender.date)
    }
    
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    
    
    
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < categories.count,
              indexPath.item < categories[indexPath.section].trackers.count else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let completedDaysCount = viewModel.completedDaysCount(for: tracker)
        let isCompleted = viewModel.isTrackerCompleted(tracker)
        
        cell.configure(with: tracker, completedDaysCount: completedDaysCount, isCompleted: isCompleted)
        cell.onComplete = { [weak self] isCompleted in
            guard let self else { return }
            self.viewModel.handleCompleteButtonTap(tracker, isCompleted: isCompleted)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackersHeaderView.reuseIdentifier,
                for: indexPath) as? TrackersHeaderView else {
            return UICollectionReusableView()
        }

        header.configure(with: categories[indexPath.section].title)
        return header
    }
    
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 - 9
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
}
