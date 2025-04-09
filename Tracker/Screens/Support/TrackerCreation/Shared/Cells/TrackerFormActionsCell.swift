//
//  TrackerFormActionsCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerFormActionsCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonStackSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "TrackerFormActionsCell"
    
    // MARK: - Subviews
    
    private lazy var cancelButton: UIButton = {
        $0.setTitle("Отменить", for: .normal)
        $0.setTitleColor(.ypRed, for: .normal)
        $0.backgroundColor = .ypWhite
        $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        $0.layer.borderWidth = Constants.borderWidth
        $0.layer.borderColor = UIColor.ypRed.cgColor
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var createButton: UIButton = {
        $0.setTitle("Создать", for: .normal)
        $0.setTitleColor(.ypWhite, for: .normal)
        $0.backgroundColor = .ypGray
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var buttonStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.buttonStackSpacing
        $0.distribution = .fillEqually
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [cancelButton, createButton]))
    
    // MARK: - Internal Properties
    
    var onCancelButtonTapped: (() -> Void)?
    var onCreateButtonTapped: (() -> Void)?
    
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

extension TrackerFormActionsCell {
    
    func configure(isEnabled: Bool = false) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
    
}

// MARK: - Private Methods

private extension TrackerFormActionsCell {
    
    func setupCell() {
        contentView.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}

// MARK: - Actions

@objc
private extension TrackerFormActionsCell {
    
    func didTapCancelButton() {
        onCancelButtonTapped?()
    }
    
    func didTapCreateButton() {
        onCreateButtonTapped?()
    }
    
}
