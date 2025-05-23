//
//  EventFormViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 10.04.2025.
//

import UIKit

final class EventFormViewController: TrackerFormViewController {
    
    override var formTitle: String { viewModel.isEditMode ? .irregularEventEdit : .irregularEventNew }
    override var showsSchedule: Bool { false }
    
    init(viewModel: EventFormViewModelProtocol) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
