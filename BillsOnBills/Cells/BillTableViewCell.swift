//
//  BillTableViewCell.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    
    func updateView() {
        guard let bill = self.bill else { return }
        self.billNameLabel.text = bill.name
        self.amountDueLabel.text = StaticFunctions.currencyFormatter(currency: bill.amountDue)
        self.dueDateLabel.text = StaticFunctions.convertDateToString(date: bill.dueDate!)
        
        if bill.isAutoPay {
            self.autoPayLabel.layer.backgroundColor = UIColor.green.withAlphaComponent(0.5).cgColor
        } else {
            self.autoPayLabel.layer.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
        }
        
        if bill.isPaid {
            self.paidButton.setTitle("Paid", for: .normal)
            self.paidButton.backgroundColor = Constants.blueColor
        } else {
            self.paidButton.setTitle("Pay", for: .normal)
            self.paidButton.backgroundColor = Constants.yellowMainColor
        }
        paidButton.addTarget(self, action: #selector(paidButtonTapped), for: .touchUpInside)
    }
    
    @objc func paidButtonTapped() {
        delegate?.paidButtonTapped(sender: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(autoPayLabel)
        self.contentView.addSubview(billNameLabel)
        self.contentView.addSubview(amountDueLabel)
        self.contentView.addSubview(dueDateLabel)
        self.contentView.addSubview(paidButton)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        autoPayLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        autoPayLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        autoPayLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        autoPayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        billNameLabel.leadingAnchor.constraint(equalTo: self.autoPayLabel.trailingAnchor, constant: 5).isActive = true
        billNameLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        billNameLabel.bottomAnchor.constraint(equalTo: self.dueDateLabel.topAnchor, constant: 5).isActive = true
        
        amountDueLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        amountDueLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        amountDueLabel.leadingAnchor.constraint(equalTo: self.billNameLabel.trailingAnchor, constant: 10).isActive = true
        
        paidButton.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        paidButton.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        paidButton.leadingAnchor.constraint(equalTo: self.amountDueLabel.trailingAnchor, constant: 10).isActive = true
        paidButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        paidButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dueDateLabel.leadingAnchor.constraint(equalTo: self.autoPayLabel.trailingAnchor, constant: 5).isActive = true
        dueDateLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        dueDateLabel.trailingAnchor.constraint(equalTo: self.amountDueLabel.leadingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var bill: Bill? {
        didSet {
            self.updateView()
        }
    }
    
    weak var delegate: BillCellDelegate?
    
    // MARK: - UIViews
    
    let billNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Constants.grayMainColor
        return label
    }()
    
    let amountDueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 30)
        label.textAlignment = .right
        label.textColor = Constants.blueMainColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 12)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let paidButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.yellowMainColor
        button.layer.cornerRadius = 25
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let autoPayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "A"
        label.layer.cornerRadius = 12.5
        return label
    }()
}

protocol BillCellDelegate: class {
    func paidButtonTapped(sender: BillTableViewCell)
}
