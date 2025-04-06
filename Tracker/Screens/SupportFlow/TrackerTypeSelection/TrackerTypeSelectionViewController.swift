//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 04.04.2025.
//

import UIKit

class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
        static let stackSpacing: CGFloat = 16
        static let horizontalInset: CGFloat = 20
    }
    
    // MARK: - Subviews
    
    private lazy var habitButton: UIButton = {
        $0.setTitle("Привычка", for: .normal)
        $0.backgroundColor = .ypBlack
        $0.tintColor = .ypWhite
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var eventButton: UIButton = {
        $0.setTitle("Нерегулярное событие", for: .normal)
        $0.backgroundColor = .ypBlack
        $0.tintColor = .ypWhite
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var vStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.stackSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [habitButton, eventButton]))
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: - Initialization

}

// MARK: - Private Methods

private extension TrackerTypeSelectionViewController {
    
    func setupViewController() {
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Создание трекера" // TODO: цвет заголовков
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            eventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.horizontalInset),
            vStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
}

// MARK: - Actions

@objc
private extension TrackerTypeSelectionViewController {
    
    func didTapHabitButton() {
        
    }
    
    func didTapEventButton() {
        
    }
    
}
