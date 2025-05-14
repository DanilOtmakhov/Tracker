//
//  OnboardingStepViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 06.05.2025.
//

import UIKit

struct OnboardingPageData {
    let title: String
    let imageResource: ImageResource
}

final class OnboardingStepViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelLeadingTrailingInset: CGFloat = 16
        static let labelToButtonSpacing: CGFloat = 160
        static let buttonLeadingTrailingInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = 50
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 16
    }
    
    // MARK: - Views
    
    private lazy var label: UILabel = {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .ypBlack
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var backgroundImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var button: UIButton = {
        $0.setTitle(.onboardingButton, for: .normal)
        $0.setTitleColor(.ypWhite, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .ypBlack
        $0.layer.cornerRadius = Constants.buttonCornerRadius
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Internal Methods
    
    var onButtonTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let pageData: OnboardingPageData
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Initialization
    
    init(pageData: OnboardingPageData) {
        self.pageData = pageData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Methods

private extension OnboardingStepViewController {
    
    func setupViewController() {
        label.text = pageData.title
        backgroundImageView.image = UIImage(resource: pageData.imageResource)
        
        [backgroundImageView, label, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelLeadingTrailingInset),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.labelLeadingTrailingInset),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -Constants.labelToButtonSpacing),
            
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonLeadingTrailingInset),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonLeadingTrailingInset),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonBottomInset),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
}

// MARK: - Actions

@objc
private extension OnboardingStepViewController {
    
    func didTapButton() {
        onButtonTapped?()
    }
    
}
