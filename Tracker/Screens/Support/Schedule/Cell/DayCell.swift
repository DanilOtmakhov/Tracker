//
//  DayCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class DayCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let switchViewWidth: CGFloat = 51
        static let switchViewHeight: CGFloat = 31
    }
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "DayCell"
    
    // MARK: - Subviews
    
    private lazy var dayLabel: UILabel = {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .ypBlack
        return $0
    }(UILabel())
    
    private lazy var switchView: UISwitch = {
        $0.onTintColor = .ypBlue
        $0.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return $0
    }(UISwitch())
    
    // MARK: - Internal Properties
    
    var onSwitchToggled: ((Bool) -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Methods

extension DayCell {
    
    func configure(with day: Day, isSelected: Bool) {
        dayLabel.text = day.string
        switchView.isOn = isSelected
    }
    
}

// MARK: - Private Methods

private extension DayCell {
    
    func setupCell() {
        backgroundColor = .background
            
        [dayLabel, switchView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchView.leadingAnchor.constraint(greaterThanOrEqualTo: dayLabel.trailingAnchor),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            switchView.widthAnchor.constraint(equalToConstant: Constants.switchViewWidth),
            switchView.heightAnchor.constraint(equalToConstant: Constants.switchViewHeight),
            switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

// MARK: - Actions

@objc
private extension DayCell {
    
    func switchValueChanged(_ sender: UISwitch) {
        onSwitchToggled?(sender.isOn)
    }
    
}
