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
        static let daysRowHeight: CGFloat = 38
        static let titleRowHeight: CGFloat = 75
        static let optionRowHeight: CGFloat = 75
        static let emojiRowHeight: CGFloat = 204
        static let colorRowHeight: CGFloat = 204
        static let actionsRowHeight: CGFloat = 60
        
        static let warningLabelTopOffset: CGFloat = 8
        static let warningLabelHeight: CGFloat = 22
    }
    
    private enum Section: Int, CaseIterable {
        case days
        case title
        case options
        case emoji
        case color
        case actions
    }
    
    // MARK: - Internal Properties
    
    var formTitle: String { viewModel.isEditMode ? .habitEdit : .habitNew }
    var showsSchedule: Bool { true }
    
    var onCategoryCellTapped: (() -> Void)?
    var onScheduleCellTapped: (() -> Void)?
    var onCompleteButtonTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    var viewModel: TrackerFormViewModelProtocol
    
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
        
        tableView.register(TrackerFormCompletedDaysCell.self,
                           forCellReuseIdentifier: TrackerFormCompletedDaysCell.reuseIdentifier)
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
        case .days:
            return viewModel.isEditMode ? 1 : 0
        case .options:
            return showsSchedule ? 2 : 1
        case .title, .emoji, .color, .actions:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .days:
            guard
                let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormCompletedDaysCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormCompletedDaysCell,
                let completedDaysCount = viewModel.completedDaysCount()
            else {
                return UITableViewCell()
            }
            
            cell.configure(with: completedDaysCount)
            
            return cell
            
        case .title:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormTitleCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormTitleCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: viewModel.title)
            
            cell.onTextChanged = { [weak self] title in
                self?.viewModel.enterTitle(title)
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
                cell.configure(isCategory: true, detailText: viewModel.selectedCategory?.title)
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
            
            cell.configure(with: viewModel.selectedEmoji)
            
            cell.onItemSelected = { [weak self] emoji in
                self?.viewModel.selectEmoji(emoji)
            }
            
            return cell
            
        case .color:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormColorsCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormColorsCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: viewModel.selectedColor)
            
            cell.onItemSelected = { [weak self] color in
                self?.viewModel.selectColor(color)
            }
            
            return cell
            
        case .actions:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackerFormActionsCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerFormActionsCell else {
                return UITableViewCell()
            }
            
            cell.configure(isEnabled: viewModel.isFormValid, isEditMode: viewModel.isEditMode)
            
            cell.onCancelButtonTapped = { [weak self] in
                self?.dismiss(animated: true)
            }
            
            cell.onCompleteButtonTapped = { [weak self] in
                self?.viewModel.completeForm()
                self?.onCompleteButtonTapped?()
            }
            
            return cell
        }
    }
    
}

// MARK: - Delegate

extension TrackerFormViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
        case .days:
            return Constants.daysRowHeight
        case .title:
            return Constants.titleRowHeight
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
        if indexPath.section == Section.options.rawValue {
            if indexPath.row == 0 {
                onCategoryCellTapped?()
            } else {
                onScheduleCellTapped?()
            }
        }
    }
    
}


