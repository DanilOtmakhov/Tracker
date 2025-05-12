//
//  TrackerFormTitleCell.swift
//  Tracker
//
//  Created by Danil Otmakhov on 08.04.2025.
//

import UIKit

final class TrackerFormTitleCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let maxTitleLength: Int = 38
    }
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "TrackerFormTitleCell"
    
    // MARK: - Subviews
    
    private lazy var titleTextField: UITextField = {
        $0.placeholder = "Введите название трекера"
        $0.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                .foregroundColor: UIColor.ypGray
            ]
        )
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .ypBlack
        $0.backgroundColor = .background
        $0.clearButtonMode = .whileEditing
        $0.delegate = self
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextField())
    
    // MARK: - Internal Properties
    
    var onTextChanged: ((String) -> Void)?
    
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

extension TrackerFormTitleCell {
    
    func configure(with title: String?) {
        titleTextField.text = title
    }
    
}

// MARK: - Private Methods

private extension TrackerFormTitleCell {
    
    func setupCell() {
        contentView.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}

// MARK: - UITextFieldDelegate

extension TrackerFormTitleCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onTextChanged?(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= Constants.maxTitleLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
