//
//  TrackerFormOptionCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerFormOptionCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "TrackerFormOptionCell"
    
    // MARK: - Private Properties
    
    private var selectedCategory: String?
    private var selectedSchedule: String?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Internal

extension TrackerFormOptionCell {
    
    func configure(isCategory: Bool, detailText: String?) {
        textLabel?.text = isCategory ? "Категория" : "Расписание"
        detailTextLabel?.text = detailText
    }
    
}

// MARK: - Private Methods

private extension TrackerFormOptionCell {
    
    func setupCell() {
        backgroundColor = .background
        textLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.font = .systemFont(ofSize: 17)
        textLabel?.textColor = .ypBlack
        detailTextLabel?.textColor = .ypGray
        textLabel?.numberOfLines = 1
        detailTextLabel?.numberOfLines = 1
        selectionStyle = .default
        accessoryView = UIImageView(image: UIImage(resource: .chevron))
    }
    
}

