//
//  StatisticCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 20.05.2025.
//

import UIKit

final class StatisticCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let contentHorizontalInset: CGFloat = 12
        static let contentVerticalInset: CGFloat = 6
        static let labelsSpacing: CGFloat = 7
    }
    
    // MARK: - Static Properties

    static let reuseIdentifier = "StatisticCell"
    
    // MARK: - Subviews
    
    private lazy var valueLabel: UILabel = {
        $0.font = .systemFont(ofSize: 34, weight: .bold)
        $0.textColor = .ypBlack
        return $0
    }(UILabel())
    
    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .ypBlack
        return $0
    }(UILabel())
    
    private lazy var labelStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.labelsSpacing
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [valueLabel, titleLabel]))
    
    private lazy var containerView: GradientBorderView = GradientBorderView()
    
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

extension StatisticCell {
    
    func configure(value: Int, title: String) {
        valueLabel.text = String(value)
        titleLabel.text = title
    }
    
}

// MARK: - Private Methods

private extension StatisticCell {
    
    func setupCell() {
        contentView.backgroundColor = .ypWhite
        selectionStyle = .none
        
        [valueLabel, titleLabel, labelStack, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.addSubview(labelStack)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentVerticalInset),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentVerticalInset),
            
            labelStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.contentHorizontalInset),
            labelStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.contentHorizontalInset),
            labelStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.contentHorizontalInset),
            labelStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.contentHorizontalInset)
        ])
    }
    
}


