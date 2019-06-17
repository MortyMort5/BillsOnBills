//
//  AddBillView.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit


class AddBillView: UIView, UITextFieldDelegate {
    static let shared = AddBillView()
    
    func showAddBillView() {
        self.addSubview(transparentView)
        
        nameTextfield.delegate = self
        amountDueTextfield.delegate = self
        
        self.buttonStackView.addArrangedSubview(cancelButton)
        self.buttonStackView.addArrangedSubview(saveButton)
        
        self.stackView.addArrangedSubview(nameTextfield)
        self.stackView.addArrangedSubview(amountDueTextfield)
        self.stackView.addArrangedSubview(dueDateTextField)
        self.stackView.addArrangedSubview(buttonStackView)
        
        self.transparentView.addSubview(stackView)
        self.transparentView.bringSubviewToFront(stackView)
        
        UIApplication.shared.keyWindow?.addSubview(transparentView)
        
        stackView.centerXAnchor.constraint(equalTo: self.transparentView.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.transparentView.topAnchor, constant: 200).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.transparentView.widthAnchor, multiplier: 0.7).isActive = true
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        self.dueDatePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        self.dueDateTextField.inputView = dueDatePicker
        
        self.nameTextfield.becomeFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextfield:
            amountDueTextfield.becomeFirstResponder()
        case amountDueTextfield:
            dueDateTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat =  Constants.dateFormat
        self.dueDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func cancelButtonTapped() {
        self.transparentView.removeFromSuperview()
    }
    
    @objc func saveButtonTapped() {
        guard let name = nameTextfield.text, !name.isEmpty,
            let amountDueString = amountDueTextfield.text, !amountDueString.isEmpty,
            let dueDateString = dueDateTextField.text, !dueDateString.isEmpty else { return }
        
        guard let amountDueDouble = Float(amountDueString) else { return }

        let amountDue = Float(round(100 * amountDueDouble) / 100)
        
        let formatter = DateFormatter()
        formatter.dateFormat =  Constants.dateFormat
        guard let date = formatter.date(from: dueDateString) else { return }
        
        BillController.shared.addBill(name: name, amountDue: amountDue, dueDate: date)
        self.transparentView.removeFromSuperview()
    }
    
    lazy var transparentView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let nameTextfield: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 200, width: 50, height: 25))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "bill name:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let amountDueTextfield: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 300, width: 50, height: 25))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "amount due each month:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let dueDateTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 400, width: 50, height: 25))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "due date:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 5
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 5
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
}
