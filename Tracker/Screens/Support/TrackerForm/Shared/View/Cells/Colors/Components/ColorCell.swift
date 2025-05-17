//
//  ColorCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    private enum Constants {
        static let colorViewSize: CGFloat = 40
        static let colorRadius: CGFloat = 8
        static let borderWidth: CGFloat = 3
    }
    
    static let reuseIdentifier = "ColorCell"
    
    private lazy var colorView: UIView = {
        $0.layer.cornerRadius = Constants.colorRadius
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
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = Constants.colorRadius
        contentView.layer.borderWidth = Constants.borderWidth
        
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: Constants.colorViewSize),
            colorView.heightAnchor.constraint(equalToConstant: Constants.colorViewSize)
        ])
    }
    
}


