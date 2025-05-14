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
    
    private lazy var completedDaysCountLabel: UILabel = {
        $0.textColor = .ypBlack
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var completeButton: UIButton = {
        $0.tintColor = .ypWhite
        $0.setImage(UIImage(resource: .plus), for: .normal)
        $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        $0.layer.cornerRadius = 17
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    // MARK: - Internal Properties
    
    var onComplete: ((Bool) -> Void)?
    
    // MARK: - Private Methods
    
    private var completedDaysCount: Int = 0 {
        didSet {
            updateCompletedDaysCountLabel(completedDaysCount)
        }
    }
    
    private var isCompleted: Bool = false {
        didSet {
            updateCompleteButtonAppearance(isCompleted)
        }
    }
    
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
    
    func configure(with tracker: Tracker, completedDaysCount: Int, isCompleted: Bool) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.title
        
        containerView.backgroundColor = tracker.color
        completeButton.backgroundColor = tracker.color
        
        self.completedDaysCount = completedDaysCount
        self.isCompleted = isCompleted
    }
    
    func updateState(completedDaysCount: Int, isCompleted: Bool) {
        self.completedDaysCount = completedDaysCount
        self.isCompleted = isCompleted
    }
    
}

// MARK: - Private Methods

private extension TrackerCell {
    
    func setupCell() {
        contentView.backgroundColor = .ypWhite
        
        [containerView, completedDaysCountLabel, completeButton].forEach {
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
            
            completedDaysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            completedDaysCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -8),
            completedDaysCountLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func updateCompletedDaysCountLabel(_ count: Int) {
        completedDaysCountLabel.text = .daysCount.localizedPluralized(count: count)
    }
    
    func updateCompletedDaysCount(_ isCompleted: Bool) {
        switch isCompleted {
        case true:
            completedDaysCount += 1
        case false:
            completedDaysCount -= 1
        }
    }
    
    func updateCompleteButtonAppearance(_ isCompleted: Bool) {
        switch isCompleted {
        case true:
            completeButton.setImage(UIImage(resource: .done), for: .normal)
            completeButton.alpha = 0.3
        case false:
            completeButton.setImage(UIImage(resource: .plus), for: .normal)
            completeButton.alpha = 1
        }
    }
    
}

// MARK: - Actions

@objc
private extension TrackerCell {
    
    func didTapCompleteButton() {
        isCompleted.toggle()
        updateCompletedDaysCount(isCompleted)
        onComplete?(isCompleted)
    }
    
}
