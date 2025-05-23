//
//  TrackerFormCompletedDaysCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 19.05.2025.
//

import UIKit

final class TrackerFormCompletedDaysCell: UITableViewCell {
    
    // MARK: - Static Properties

    static let reuseIdentifier = "TrackerFormCompletedDaysCell"
    
    // MARK: - Subviews
    
    private lazy var daysCountLabel: UILabel = {
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
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

extension TrackerFormCompletedDaysCell {
    
    func configure(with daysCount: Int) {
        daysCountLabel.text = .daysCount.localizedPluralized(count: daysCount)
    }
    
}

// MARK: - Private Methods

private extension TrackerFormCompletedDaysCell {
    
    func setupCell() {
        contentView.backgroundColor = .ypWhite
        contentView.addSubview(daysCountLabel)
        
        NSLayoutConstraint.activate([
            daysCountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            daysCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
