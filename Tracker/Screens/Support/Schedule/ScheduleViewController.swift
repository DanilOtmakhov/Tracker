//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let rowHeight: CGFloat = 75
        static let tableViewToButtonSpacing: CGFloat = 16
        
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = -16
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .ypWhite
        $0.separatorStyle = .singleLine
        $0.separatorColor = .ypGray
        $0.allowsSelection = false 
        $0.register(DayCell.self,
                    forCellReuseIdentifier: DayCell.reuseIdentifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return $0
    }(UITableView(frame: .zero, style: .insetGrouped))
    
    private lazy var readyButton: UIButton = {
        $0.setTitle("Готово", for: .normal)
        $0.setTitleColor(.ypWhite, for: .normal)
        $0.backgroundColor = .ypBlack
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Internal Properties
    
    var onDaysSelected: (([Day]) -> Void)?
    var selectedDays: Set<Day> = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

}

// MARK: - Private Methods

private extension ScheduleViewController {
    
    func setupViewController() {
        title = .schedule
        view.backgroundColor = .ypWhite
        
        [tableView, readyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -Constants.tableViewToButtonSpacing),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomInset),
            readyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

}

// MARK: - Actions

@objc
private extension ScheduleViewController {
    
    func didTapReadyButton() {
        onDaysSelected?(Array(selectedDays.sorted()))
    }
    
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Day.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DayCell.reuseIdentifier,
            for: indexPath
        ) as? DayCell
        else {
            return UITableViewCell()
        }
        
        let day = Day.allCases[indexPath.row]
        let isSelected = selectedDays.contains(day)
        cell.configure(with: day, isSelected: isSelected)
        
        cell.onSwitchToggled = { [weak self] isOn in
            guard let self else { return }
            if isOn {
                self.selectedDays.insert(day)
            } else {
                self.selectedDays.remove(day)
            }
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
}
