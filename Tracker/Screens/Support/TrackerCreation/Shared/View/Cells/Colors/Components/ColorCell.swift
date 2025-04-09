//
//  ColorCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    private enum Constants {
        static let colorViewInsets: CGFloat = 6
        static let colorViewCornerRadius: CGFloat = 8
    }
    
    static let reuseIdentifier = "ColorCell"
    
    private lazy var colorView: UIView = {
        $0.layer.cornerRadius = Constants.colorViewCornerRadius
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    private func setupCell() {
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.colorViewInsets),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.colorViewInsets),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.colorViewInsets),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.colorViewInsets)
        ])
    }
}


