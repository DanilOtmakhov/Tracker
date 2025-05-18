//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let collectionViewHorizontalInset: CGFloat = 16
        static let collectionViewInteritemSpacing: CGFloat = 9
        static let collectionViewMinimumLineSpacing: CGFloat = 0
        static let cellHeight: CGFloat = 148
        static let headerHeight: CGFloat = 50
        
        static let stubImageSize: CGFloat = 80
        static let stubImageTopOffset: CGFloat = -40
        
        static let stubLabelTopOffset: CGFloat = 8
        
        static let datePickerWidth: CGFloat = 110
        
        static let cornerRadius: CGFloat = 16
        static let buttonWidth: CGFloat = 114
        static let buttonHeight: CGFloat = 50
        static let buttonBottomInset: CGFloat = -16
    }
    
    // MARK: - Subviews
    
    private lazy var datePicker: UIDatePicker = {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.maximumDate = Date()
        $0.locale = Locale.current
        $0.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    private lazy var stubImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    private lazy var stubLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var searchController: UISearchController = {
        $0.searchResultsUpdater = self
        $0.searchBar.placeholder = .search
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.tintColor = .ypGray
        $0.searchBar.setValue(String.cancel, forKey: "cancelButtonText")
        return $0
    }(UISearchController())
    
    private lazy var collectionView: UICollectionView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .ypWhite
        $0.alwaysBounceVertical = true
        $0.contentInset = UIEdgeInsets(top: 0, left: Constants.collectionViewHorizontalInset, bottom: 0, right: Constants.collectionViewHorizontalInset)
        $0.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        $0.register(TrackersHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersHeaderView.reuseIdentifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    private lazy var filtersButton: UIButton = {
        $0.setTitle(.filters, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17)
        $0.backgroundColor = .ypBlue
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Internal Properties
    
    var onAddTrackerTapped: (() -> Void)?
    var onFiltersButtonTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var viewModel: TrackersViewModelProtocol
    
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
        setupAppearance()
        setupTapGesture()
        setupViewModel()
    }
    
}

// MARK: - Private Methods

private extension TrackersViewController {
    
    func setupViewController() {
        view.backgroundColor = .ypWhite
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = .trackers
        navigationItem.searchController = searchController
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .plus),
            style: .done,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        [collectionView, stubImageView, stubLabel, filtersButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: Constants.datePickerWidth),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.stubImageTopOffset),
            stubImageView.heightAnchor.constraint(equalToConstant: Constants.stubImageSize),
            stubImageView.widthAnchor.constraint(equalToConstant: Constants.stubImageSize),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: Constants.stubLabelTopOffset),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filtersButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            filtersButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomInset)
        ])
    }
    
    
    
    func setupAppearance() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes(attributes, for: .normal)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearchBar))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.applyUpdate(state)
            }
        }
        
        viewModel.onDateChange = { [weak self] date in
            self?.datePicker.setDate(date, animated: true)
        }
    }
    
    func applyUpdate(_ state: TrackersViewModelState) {
        let update = state.update
        switch state {
        case .content:
            self.stubImageView.isHidden = true
            self.stubLabel.isHidden = true
            self.collectionView.isHidden = false
            self.filtersButton.isHidden = false
            
            if update.isEmpty {
                collectionView.reloadData()
                return
            }
            
            collectionView.performBatchUpdates {
                if !update.insertedSections.isEmpty {
                    collectionView.insertSections(update.insertedSections)
                }
                
                if !update.deletedSections.isEmpty {
                    collectionView.deleteSections(update.deletedSections)
                }
                
                if !update.insertedIndexPaths.isEmpty {
                    collectionView.insertItems(at: update.insertedIndexPaths)
                }
                if !update.deletedIndexPaths.isEmpty {
                    collectionView.deleteItems(at: update.deletedIndexPaths)
                }
                if !update.updatedIndexPaths.isEmpty {
                    collectionView.reloadItems(at: update.updatedIndexPaths)
                }
                for move in update.movedIndexPaths {
                    collectionView.moveItem(at: move.from, to: move.to)
                }
            }
            
        case .empty:
            self.filtersButton.isHidden = true
            self.updateStubView(image: UIImage(resource: .stub),
                                labelText: .trackersEmptyState)
        case .searchNotFound:
            self.filtersButton.isHidden = false
            self.updateStubView(image: UIImage(resource: .nothingFound),
                                labelText: .nothingFound)
        }
    }
    
    func updateStubView(image: UIImage?, labelText: String) {
        stubImageView.image = image
        stubLabel.text = labelText
        stubImageView.isHidden = false
        stubLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    func showDeleteConfirmationAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(
            title: nil,
            message: .deleteTrackerConfirmation,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: .delete,
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.deleteTracker(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: .cancel, style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

// MARK: - Actions

@objc
private extension TrackersViewController {
    
    func didTapAddButton() {
        onAddTrackerTapped?()
    }
    
    func didTapFiltersButton() {
        onFiltersButtonTapped?()
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.filterTrackers(by: sender.date)
    }
    
    func handleTapOutsideSearchBar() {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
            searchController.isActive = false
        }
    }
    
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchTrackers(with: searchText)
    }
    
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell,
            let tracker = viewModel.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        let completedDaysCount = viewModel.completedDaysCount(for: tracker)
        let isCompleted = viewModel.isTrackerCompleted(tracker)
        
        cell.configure(with: tracker, completedDaysCount: completedDaysCount, isCompleted: isCompleted)
        
        cell.onComplete = { [weak self] isCompleted in
            guard let self else { return }
            self.viewModel.handleCompleteButtonTap(tracker, isCompleted: isCompleted)
            
            let newCompletedDaysCount = self.viewModel.completedDaysCount(for: tracker)
            let newIsCompleted = self.viewModel.isTrackerCompleted(tracker)
            
            cell.updateState(completedDaysCount: newCompletedDaysCount, isCompleted: newIsCompleted)
        }
        
        cell.onActionSelected = { [weak self] action in
            switch action {
            case .pin:
                break
            case .edit:
                break
            case .delete:
                self?.showDeleteConfirmationAlert(for: indexPath)
            }
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackersHeaderView.reuseIdentifier,
                for: indexPath) as? TrackersHeaderView,
            let title = viewModel.nameOfSection(at: indexPath)
        else {
            return UICollectionReusableView()
        }

        header.configure(with: title)
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - Constants.collectionViewHorizontalInset * 2 - Constants.collectionViewInteritemSpacing
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.headerHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionViewInteritemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Constants.collectionViewMinimumLineSpacing
    }
    
}
