//
//  CategoryCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 10.05.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let imageViewWidth: CGFloat = 24
        static let imageViewHeight: CGFloat = 24
    }
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "CategoryCell"
    
    // MARK: - Subviews
    
    private lazy var categoryLabel: UILabel = {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .ypBlack
        return $0
    }(UILabel())
    
    private lazy var selectedImageView: UIImageView = {
        $0.image = UIImage(resource: .blueDone)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        return $0
    }(UIImageView())
    
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

extension CategoryCell {
    
    func configure(with title: String) {
        categoryLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedImageView.isHidden = !selected
    }
    
}

// MARK: - Private Methods

private extension CategoryCell {
    
    func setupCell() {
        backgroundColor = .background
        selectionStyle = .none
            
        [categoryLabel, selectedImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            selectedImageView.leadingAnchor.constraint(greaterThanOrEqualTo: categoryLabel.trailingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            selectedImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewWidth),
            selectedImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight),
            selectedImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
