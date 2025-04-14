//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

class TrackerFormViewController: UITableViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let nameRowHeight: CGFloat = 75
        static let optionRowHeight: CGFloat = 75
        static let emojiRowHeight: CGFloat = 204
        static let colorRowHeight: CGFloat = 204
        static let actionsRowHeight: CGFloat = 60
    }
    
    private enum Section: Int, CaseIterable {
        case title
        case options
        case emoji
        case color
        case actions
    }
    
    // MARK: - Internal Properties
    
    var formTitle: String { "Новая привычка" }
    var showsSchedule: Bool { true }
    
    var onScheduleCellTapped: (() -> Void)?
    var onCreatedButtonTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var viewModel: TrackerFormViewModelProtocol
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupViewModel()
    }
    
    // MARK: - Initialization
    
    init(viewModel: TrackerFormViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Methods

private extension TrackerFormViewController {
    
    func setupViewController() {
        title = formTitle
        view.backgroundColor = .ypWhite
        setupTableView()
        setupTapGesture()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .ypWhite
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        
        tableView.register(TrackerFormTitleCell.self,
                           forCellReuseIdentifier: TrackerFormTitleCell.reuseIdentifier)
        tableView.register(TrackerFormOptionCell.self,
                           forCellReuseIdentifier: TrackerFormOptionCell.reuseIdentifier)
        tableView.register(TrackerFormActionsCell.self,
                           forCellReuseIdentifier: TrackerFormActionsCell.reuseIdentifier)
        tableView.register(TrackerFormEmojiCell.self,
                           forCellReuseIdentifier: TrackerFormEmojiCell.reuseIdentifier)
        tableView.register(TrackerFormColorsCell.self,
                           forCellReuseIdentifier: TrackerFormColorsCell.reuseIdentifier)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func setupViewModel() {
        viewModel.onFormUpdated = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }

}

// MARK: - Actions

@objc
private extension TrackerFormViewController {
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Data Source

extension TrackerFormViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .options:
            return showsSchedule ? 2 : 1
        case .title, .emoji, .color, .actions:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .title:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormTitleCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormTitleCell else {
                return UITableViewCell()
            }
            
            cell.onTextChanged = { [weak self] title in
                self?.viewModel.didEnterTitle(title)
            }
            
            return cell
            
        case .options:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormOptionCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormOptionCell else {
                return UITableViewCell()
            }
            
            if indexPath.row == 0 {
                cell.configure(isCategory: true, detailText: viewModel.selectedCategory)
            } else {
                if let habitViewModel = viewModel as? HabitFormViewModelProtocol {
                    cell.configure(isCategory: false, detailText: habitViewModel.selectedDaysString)
                }
            }
            return cell
            
        case .emoji:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormEmojiCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormEmojiCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .color:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormColorsCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormColorsCell else {
                return UITableViewCell()
            }
            
            return cell
            
        case .actions:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormActionsCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormActionsCell else {
                return UITableViewCell()
            }
            
            cell.configure(isEnabled: viewModel.isFormValid)
            
            cell.onCancelButtonTapped = { [weak self] in
                self?.dismiss(animated: true)
            }
            
            cell.onCreateButtonTapped = { [weak self] in
                self?.viewModel.createTracker()
                self?.onCreatedButtonTapped?()
            }
            
            return cell
        }
    }
    
}

// MARK: - Delegate

extension TrackerFormViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
        case .title:
            return Constants.nameRowHeight
        case .options:
            return Constants.optionRowHeight
        case .emoji:
            return Constants.emojiRowHeight
        case .color:
            return Constants.colorRowHeight
        case .actions:
            return Constants.actionsRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == Section.options.rawValue && indexPath.row == 1 {
            onScheduleCellTapped?()
        }
    }
    
}


