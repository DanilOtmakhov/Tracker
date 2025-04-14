//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 28.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
}

// MARK: - Private Methods

private extension StatisticsViewController {
    
    func setupViewController() {
        view.backgroundColor = .ypWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Статистика"
    }
    
}
