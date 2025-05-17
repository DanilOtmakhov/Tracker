//
//  HabitFormViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 10.04.2025.
//

import UIKit

final class HabitFormViewController: TrackerFormViewController {
    
    override var formTitle: String { .habitNew }
    override var showsSchedule: Bool { true }
    
    init(viewModel: HabitFormViewModelProtocol) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
