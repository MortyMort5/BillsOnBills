//
//  BillDetailViewController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/20/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addBill))
        
        updateView()
    }
    
    func updateView() {
        nameTextfield.delegate = self
        amountDueTextfield.delegate = self
        
        stackView.addArrangedSubview(nameTextfield)
        stackView.addArrangedSubview(amountDueTextfield)
        stackView.addArrangedSubview(dueDateTextField)
        self.view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        
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
    
    @objc func addBill() {
        guard let name = nameTextfield.text, !name.isEmpty,
            let amountDueString = amountDueTextfield.text, !amountDueString.isEmpty,
            let dueDateString = dueDateTextField.text, !dueDateString.isEmpty else { return }
        
        guard let amountDueDouble = Float(amountDueString) else { return }
        
        let amountDue = Float(round(100 * amountDueDouble) / 100)
        
        let formatter = DateFormatter()
        formatter.dateFormat =  Constants.dateFormat
        guard let date = formatter.date(from: dueDateString) else { return }
        
        BillController.shared.addBill(name: name, amountDue: amountDue, dueDate: date)
        navigationController?.popViewController(animated: true)
        
        self.nameTextfield.text = ""
        self.amountDueTextfield.text = ""
        self.dueDateTextField.text = StaticFunctions.convertDateToString(date: Date())
    }
    
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
        textField.text = StaticFunctions.convertDateToString(date: Date())
        return textField
    }()
    
    let dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        //        datePicker.minimumDate = Date()
        return datePicker
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
