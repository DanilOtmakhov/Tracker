//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 07.05.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let rowHeight: CGFloat = 75
        static let tableViewToButtonSpacing: CGFloat = 16
        
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = -16
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
        
        static let stubImageSize: CGFloat = 80
        static let stubTopOffset: CGFloat = -100
        static let stubLabelTopOffset: CGFloat = 8
        static let stubLabelWidth: CGFloat = 200
    }
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .ypWhite
        $0.separatorStyle = .singleLine
        $0.separatorColor = .ypGray
        $0.allowsSelection = true
        $0.register(CategoryCell.self,
                    forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return $0
    }(UITableView(frame: .zero, style: .insetGrouped))
    
    private lazy var stubImageView: UIImageView = {
        $0.image = UIImage(resource: .stub)
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var stubLabel: UILabel = {
        $0.text = "Привычки и события можно объединить по смыслу"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var addButton: UIButton = {
        $0.setTitle("Добавить категорию", for: .normal)
        $0.backgroundColor = .ypBlack
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Private Properties
    
    private var viewModel: CategoriesViewModelProtocol
    
    // MARK: - Initialization
    
    init(viewModel: CategoriesViewModelProtocol) {
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
    
}

// MARK: - Private Methods

private extension CategoriesViewController {
    
    func setupViewController() {
        title = "Категория"
        view.backgroundColor = .ypWhite

        [tableView, addButton, stubImageView, stubLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -Constants.tableViewToButtonSpacing),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomInset),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.stubTopOffset),
            stubImageView.heightAnchor.constraint(equalToConstant: Constants.stubImageSize),
            stubImageView.widthAnchor.constraint(equalToConstant: Constants.stubImageSize),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: Constants.stubLabelTopOffset),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.widthAnchor.constraint(equalToConstant: Constants.stubLabelWidth)
        ])
    }
    
    func setupViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.applyUpdate(state)
        }
    }
    
    func applyUpdate(_ state: CategoriesViewModelState) {
        let update = state.update
        switch state {
        case .content:
            stubImageView.isHidden = true
            stubLabel.isHidden = true
            tableView.isHidden = false
            
            tableView.performBatchUpdates {
                tableView.insertRows(at: update.insertedIndexPaths, with: .automatic)
                tableView.deleteRows(at: update.deletedIndexPaths, with: .fade)
                tableView.reloadRows(at: update.updatedIndexPaths, with: .automatic)
                
                for move in update.movedIndexPaths {
                    tableView.moveRow(at: move.from, to: move.to)
                }
            }
        case .empty:
            stubImageView.isHidden = false
            stubLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    
    
    
}

// MARK: - Actions

@objc
private extension CategoriesViewController {
    
    func didTapAddButton() {
        
    }
    
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCell,
            let title = viewModel.categoryTitle(at: indexPath)
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: title)
        
        if viewModel.isCategorySelected(at: indexPath) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCategory(at: indexPath)
    
        if viewModel.isCategorySelected(at: indexPath) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
}
