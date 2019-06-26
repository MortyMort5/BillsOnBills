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
        
        updateView()
    }
    
    func updateView() {
        nameTextfield.delegate = self
        amountDueTextfield.delegate = self
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        stackView.addArrangedSubview(nameTextfield)
        stackView.addArrangedSubview(amountDueTextfield)
        stackView.addArrangedSubview(dueDateTextField)
        stackView.addArrangedSubview(dayPickerView)
        self.view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        
        self.updateDueDateTextField(day: Calendar.current.component(.day, from: Date()))
        dayPickerView.selectRow(Calendar.current.component(.day, from: Date()) - 1, inComponent: 0, animated: true)
        
        self.nameTextfield.becomeFirstResponder()
    }
    
    // MARK: - Delegate Functions
    
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
    
    func updateDueDateTextField(day: Int) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        self.dueDateTextField.text = "\(month) / \(day) / \(year)"
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 36.0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 30
//    }
    
    // MARK: - Action Selector Functions
    
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
    
    // MARK: - UIViews
    
    let nameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "bill name:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let amountDueTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "amount due each month:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let dueDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "due date:"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
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
}
