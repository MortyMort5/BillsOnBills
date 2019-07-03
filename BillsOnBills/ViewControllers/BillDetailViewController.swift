//
//  BillDetailViewController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/20/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addBill))
    
        setUpView()
    }
    
    // MARK: - Text Field Delegate
    
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
    
    // MARK: - UIPickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 27
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var arr = [Int]()
        arr += 1...27
        return "\(arr[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        self.updateDueDateTextField(day: row + 1)
    }
    
    // MARK: - Action Selector Functions
    
    @objc func addBill() {
        guard let name = nameTextfield.text, !name.isEmpty,
            let amountDueString = amountDueTextfield.text, !amountDueString.isEmpty,
            let dueDateString = dueDateTextField.text, !dueDateString.isEmpty else { return }
        
        var amountDueStr = ""
        for str in amountDueString {
            if str == "$" || str == "," {
                // do nothing
            } else {
                amountDueStr.append(str)
            }
        }
        
        guard let amountDueDouble = Float(amountDueStr) else { return }
        
        let amountDue = Float(round(100 * amountDueDouble) / 100)
        
        let formatter = DateFormatter()
        formatter.dateFormat =  Constants.dateFormat
        guard let date = formatter.date(from: dueDateString) else { return }
        
        if let bill = self.bill {
            // modify bill
            bill.name = name
            bill.amountDue = amountDue
            bill.dueDate = date
            bill.isAutoPay = autoPaySwitch.isOn
            BillController.shared.updateBill(bill: bill)
        } else {
            // create bill
            BillController.shared.addBill(name: name, amountDue: amountDue, dueDate: date, autoPay: autoPaySwitch.isOn)
        }

        navigationController?.popViewController(animated: true)
        
        self.nameTextfield.text = ""
        self.amountDueTextfield.text = ""
        self.dueDateTextField.text = StaticFunctions.convertDateToString(date: Date())
    }
    
    @objc func amountDueTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    // MARK: - Helper Functions
    
    func updateDueDateTextField(day: Int) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        self.dueDateTextField.text = "\(month) / \(day) / \(year)"
    }
    
    func setUpView() {
        nameTextfield.delegate = self
        amountDueTextfield.delegate = self
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        autoPayContainer.addSubview(autoPayLabel)
        autoPayContainer.addSubview(autoPaySwitch)
        
        autoPayLabel.leadingAnchor.constraint(equalTo: self.autoPayContainer.leadingAnchor).isActive = true
        autoPayLabel.topAnchor.constraint(equalTo: self.autoPayContainer.topAnchor).isActive = true
        autoPayLabel.bottomAnchor.constraint(equalTo: self.autoPayContainer.bottomAnchor).isActive = true
        autoPayLabel.widthAnchor.constraint(equalTo: self.autoPayContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        autoPaySwitch.leadingAnchor.constraint(equalTo: self.autoPayLabel.trailingAnchor, constant: 5).isActive = true
        autoPaySwitch.topAnchor.constraint(equalTo: self.autoPayContainer.topAnchor).isActive = true
        autoPaySwitch.bottomAnchor.constraint(equalTo: self.autoPayContainer.bottomAnchor).isActive = true
        autoPaySwitch.trailingAnchor.constraint(equalTo: self.autoPayContainer.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(nameTextfield)
        stackView.addArrangedSubview(autoPayContainer)
        stackView.addArrangedSubview(amountDueTextfield)
        stackView.addArrangedSubview(dueDateTextField)
        stackView.addArrangedSubview(dayPickerView)
        self.view.addSubview(stackView)
        
        var frameRect = nameTextfield.frame
        frameRect.size.height = 300
        nameTextfield.frame = frameRect
        
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        
        self.updateDueDateTextField(day: Calendar.current.component(.day, from: Date()))
        dayPickerView.selectRow(Calendar.current.component(.day, from: Date()) - 1, inComponent: 0, animated: true)
        
        amountDueTextfield.addTarget(self, action: #selector(amountDueTextFieldDidChange(_:)), for: .editingChanged)
        
        self.nameTextfield.becomeFirstResponder()
    }
    
    func updateView() {
        guard let bill = self.bill else { return }
        nameTextfield.text = bill.name
        amountDueTextfield.text = String(format: "$%.02f", bill.amountDue)
        self.updateDueDateTextField(day: Calendar.current.component(.day, from: bill.dueDate!))
        dayPickerView.selectRow(Calendar.current.component(.day, from: bill.dueDate!) - 1, inComponent: 0, animated: true)
        autoPaySwitch.isOn = bill.isAutoPay
    }
    
    // MARK: - Properties
    
    var bill: Bill? {
        didSet {
            if !isViewLoaded {
                loadViewIfNeeded()
                self.updateView()
            }
        }
    }
    
    // MARK: - UIViews
    
    let nameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "bill name:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let amountDueTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "amount due each month:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let dueDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "due date:"
        textField.borderStyle = .roundedRect
        textField.text = StaticFunctions.convertDateToString(date: Date())
        return textField
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 5
        return view
    }()
    
    let dayPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        return picker
    }()
    
    let autoPayContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let autoPayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AutoPay:"
        label.textAlignment = .left
        return label
    }()
    
    let autoPaySwitch: UISwitch = {
        let autoPaySwitch = UISwitch()
        autoPaySwitch.translatesAutoresizingMaskIntoConstraints = false
        autoPaySwitch.isOn = false
        return autoPaySwitch
    }()
}
