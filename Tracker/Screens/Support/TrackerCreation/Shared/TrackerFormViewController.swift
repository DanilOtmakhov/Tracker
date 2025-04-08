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
    
    var showsSchedule: Bool { true }
    
    // MARK: - Private Properties
    
    private var viewModel: TrackerFormViewModelProtocol
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
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
        view.backgroundColor = .ypWhite
        setupTableView()
        title = "Новая привычка"
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .ypWhite
        
        
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
            let cell = TrackerFormTitleCell()
            return cell
            
        case .options:
            let cell = TrackerFormOptionCell()
            if indexPath.row == 0 {
                cell.configure(isCategory: true)
            } else {
                cell.configure(isCategory: false)
            }
            return cell
            
        case .emoji:
            let cell = TrackerFormEmojiCell()
            return cell
            
        case .color:
            let cell = TrackerFormColorsCell()
            return cell
            
        case .actions:
            let cell = TrackerFormActionsCell()
            cell.configure(isEnabled: false/*viewModel.isFormValid*/)
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
    
}

// MARK: - UITextFieldDelegate

extension TrackerFormViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            return updatedText.count <= 38
        }
        return true
    }
    
}


