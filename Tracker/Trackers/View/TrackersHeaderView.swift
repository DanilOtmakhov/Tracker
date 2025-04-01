//
//  TrackersHeaderView.swift
//  Tracker
//
//  Created by Danil Otmakhov on 01.04.2025.
//

import UIKit

final class TrackersHeaderView: UICollectionReusableView {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "TrackerHeader"
    
    // MARK: - Subviews
    
    lazy var titleLabel: UILabel = {
        $0.textColor = .ypBlack
        $0.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Properties

extension TrackersHeaderView {
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}

// MARK: - Private Methods

private extension TrackersHeaderView {
    
    func setupView() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
}
