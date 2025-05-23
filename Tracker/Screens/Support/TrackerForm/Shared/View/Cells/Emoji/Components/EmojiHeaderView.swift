//
//  EmojiHeaderView.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class EmojiHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "EmojiHeaderView"
    
    private lazy var titleLabel: UILabel = {
        $0.text = .emoji
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .ypBlack
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

