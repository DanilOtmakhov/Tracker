//
//  TrackerCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 01.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "TrackerCell"
    
    // MARK: - Subviews
    
    private lazy var emojiContainer: UIView = {
        $0.backgroundColor = .ypWhiteAlpha30
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var emojiLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignBaselines
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = .ypWhite
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var containerView: UIView = {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var daysCountLabel: UILabel = {
        $0.text = "5 дней"
        $0.textColor = .ypBlack
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var incrementDaysButton: UIButton = {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .ypWhite
        $0.layer.cornerRadius = 17
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Internal Methods

extension TrackerCell {
    
    func configure(with tracker: Tracker) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        containerView.backgroundColor = tracker.color
        incrementDaysButton.backgroundColor = tracker.color
    }
    
}

// MARK: - Private Methods

private extension TrackerCell {
    
    func setupCell() {
        contentView.backgroundColor = .ypWhite
        
        [containerView, daysCountLabel, incrementDaysButton].forEach {
            contentView.addSubview($0)
        }
        
        containerView.addSubview(emojiContainer)
        emojiContainer.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiContainer.widthAnchor.constraint(equalToConstant: 24),
            emojiContainer.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainer.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainer.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: incrementDaysButton.leadingAnchor, constant: -8),
            daysCountLabel.centerYAnchor.constraint(equalTo: incrementDaysButton.centerYAnchor),
            
            incrementDaysButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            incrementDaysButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            incrementDaysButton.widthAnchor.constraint(equalToConstant: 34),
            incrementDaysButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
}
