//
//  GradientBorderView.swift
//  Tracker
//
//  Created by Danil Otmakhov on 21.05.2025.
//

import UIKit

final class GradientBorderView: UIView {

    private enum Constants {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 16
    }

    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()

    private let gradientColors: [UIColor] = [
        .gradient1,
        .gradient2,
        .gradient3
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientBorder()
        layer.cornerRadius = Constants.cornerRadius
//        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGradientBorder() {
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: Constants.borderWidth / 2,
                                                             dy: Constants.borderWidth / 2),
                                cornerRadius: Constants.cornerRadius)
        maskLayer.path = path.cgPath
        maskLayer.fillColor = nil
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = Constants.borderWidth
    }
}

