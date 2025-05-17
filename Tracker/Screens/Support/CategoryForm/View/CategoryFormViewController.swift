//
//  CategoryFormViewController.swift
//  Tracker
//
//  Created by Danil Otmakhov on 12.05.2025.
//

import UIKit

final class CategoryFormViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let textFieldHorizontalInset: CGFloat = 16
        static let textFieldTopInset: CGFloat = 24
        static let textFieldHeight: CGFloat = 75
        
        static let buttonHorizontalInset: CGFloat = 20
        static let buttonBottomInset: CGFloat = -16
        static let buttonHeight: CGFloat = 60
        
        static let cornerRadius: CGFloat = 16
        
        static let warningLabelTopOffset: CGFloat = 8
        static let maxTitleLength: Int = 38
    }
    
    // MARK: - Subviews
    
    private lazy var titleTextField: UITextField = {
        $0.delegate = self
        $0.attributedPlaceholder = NSAttributedString(
            string: .enteringCategoryName,
            attributes: [
                .foregroundColor: UIColor.ypGray
            ]
        )
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .ypBlack
        $0.backgroundColor = .background
        $0.clearButtonMode = .whileEditing
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return $0
    }(UITextField())
    
    private lazy var warningLabel: UILabel = {
        $0.text = .characterLimit
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .ypRed
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var readyButton: UIButton = {
        $0.setTitle(.done, for: .normal)
        $0.setTitleColor(.ypWhite, for: .normal)
        $0.backgroundColor = .ypBlack
        $0.isEnabled = false
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return $0
    }(UIButton())
    // MARK: - Private Properties
    
    private var viewModel: CategoryFormViewModelProtocol
    
    // MARK: - Initialization
    
    init(viewModel: CategoryFormViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupViewModel()
    }
    

}

// MARK: - Private Methods

private extension CategoryFormViewController {
    
    func setupViewController() {
        title = viewModel.isEditMode ? .categoryEdit : .categoryNew
        view.backgroundColor = .ypWhite
        
        if viewModel.isEditMode {
            titleTextField.text = viewModel.initialTitle
            readyButton.isEnabled = true
        }
        
        [titleTextField, warningLabel, readyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldHorizontalInset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.textFieldHorizontalInset),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.textFieldTopInset),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            warningLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.warningLabelTopOffset),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalInset),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalInset),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomInset),
            readyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    func setupViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(with: state)
            }
        }
    }
    
    func updateUI(with state: CategoryFormViewModelState) {
        switch state {
        case .initial:
            readyButton.isEnabled = false
            warningLabel.isHidden = true
        case .validInput:
            readyButton.isEnabled = true
            warningLabel.isHidden = true
        case .atCharacterLimit:
            readyButton.isEnabled = true
            warningLabel.isHidden = false
        }
    }
    
}

// MARK: - Actions

@objc
private extension CategoryFormViewController {
    
    func didTapReadyButton() {
        guard let title = titleTextField.text else { return }
        viewModel.completeForm(withTitle: title)
    }
    
    func textFieldDidChange() {
        viewModel.updateTitle(titleTextField.text)
    }
    
}

// MARK: - UITextFieldDelegate

extension CategoryFormViewController: UITextFieldDelegate {
    
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
