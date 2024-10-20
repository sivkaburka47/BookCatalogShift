//
//  InputFieldView.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 18.10.2024.
//

import UIKit

protocol InputFieldViewDelegate: AnyObject {
    func inputFieldDidClearText(_ inputField: InputFieldView)
}

class InputFieldView: UIView {
    weak var delegate: InputFieldViewDelegate?
    let textField = UITextField()
    let datePicker = UIDatePicker()
    private let iconButton = UIButton(type: .system)
    
    enum InputType {
        case text
        case password
        case date
    }
    
    private var inputType: InputType
    
    init(placeholder: String, type: InputType) {
        self.inputType = type
        super.init(frame: .zero)
        setupView(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        self.inputType = .text
        super.init(coder: coder)
        setupView(placeholder: "")
    }
    
    private func setupView(placeholder: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 364).isActive = true
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.textColor = UIColor.white
        textField.textAlignment = .left
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.grayFaded
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        setupIconButton()
        
        self.addSubview(textField)
        self.addSubview(iconButton)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left),
            textField.trailingAnchor.constraint(equalTo: iconButton.leadingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom),
            
            iconButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding.right),
            iconButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.backgroundColor = UIColor.darkFaded
        self.layer.cornerRadius = 8
        
        configureForInputType()
        updateIconButtonVisibility()
    }
    
    private func setupIconButton() {
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        iconButton.tintColor = .white
        iconButton.addTarget(self, action: #selector(iconTapped), for: .touchUpInside)
        
        iconButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func configureForInputType() {
        switch inputType {
        case .text:
            iconButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            textField.textContentType = .none
            textField.keyboardType = .default
        case .password:
            iconButton.setImage(UIImage(systemName: "eye"), for: .normal)
            textField.isSecureTextEntry = true
            textField.textContentType = .newPassword
            textField.keyboardType = .asciiCapable
            textField.passwordRules = UITextInputPasswordRules(descriptor: "required: lower; required: upper; required: digit; max-consecutive: 2; minlength: 8;")
        case .date:
            iconButton.setImage(UIImage(systemName: "calendar"), for: .normal)
            setupDatePicker()
        }
        updateIconButtonVisibility()
    }
    
    @objc private func textFieldDidChange() {
        updateIconButtonVisibility()
    }
    
    private func updateIconButtonVisibility() {
        let isTextEmpty = textField.text?.isEmpty ?? true
        
        switch inputType {
        case .text, .password:
            iconButton.isHidden = isTextEmpty
        case .date:
            iconButton.isHidden = false
            iconButton.tintColor = isTextEmpty ? UIColor.grayFaded : UIColor.white
        }
    }
    
    @objc private func iconTapped() {
        switch inputType {
        case .text:
            clearText()
        case .password:
            togglePasswordVisibility()
        case .date:
            textField.becomeFirstResponder()
        }
    }
    
    private func clearText() {
        textField.text = ""
        textField.resignFirstResponder()
        updateIconButtonVisibility()
        delegate?.inputFieldDidClearText(self)
    }
    
    private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        let iconName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        iconButton.setImage(UIImage(systemName: iconName), for: .normal)
        textField.resignFirstResponder()
    }
    
    private func setupDatePicker() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let minimumYear = currentYear - 100
        let maximumYear = currentYear - 12
        
        let calendar = Calendar.current
        let minimumDate = calendar.date(from: DateComponents(year: minimumYear, month: 1, day: 1))
        let maximumDate = calendar.date(from: DateComponents(year: maximumYear, month: 12, day: 31))
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        
        textField.inputView = datePicker
        textField.inputAccessoryView = createToolBar()
        
        datePicker.setDate(minimumDate ?? Date(), animated: false)
    }


    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
           
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
           
        return toolbar
    }
       
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        textField.text = dateFormatter.string(from: datePicker.date)
        textField.resignFirstResponder()
        updateIconButtonVisibility()
    }
       
    @objc private func cancelPressed() {
        textField.resignFirstResponder()
    }
}
