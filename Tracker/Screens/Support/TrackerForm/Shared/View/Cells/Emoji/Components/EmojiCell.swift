//
//  EmojiCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCell"
    
    private lazy var emojiLabel: UILabel = {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textAlignment = .center
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
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        
        contentView.backgroundColor = isSelected ? .ypLightGray : .clear
        contentView.layer.cornerRadius = 16
    }
    
    private func setupCell() {
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}


