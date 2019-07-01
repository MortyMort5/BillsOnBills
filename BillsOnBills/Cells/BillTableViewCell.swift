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
        
        if bill.isPaid {
            self.paidButton.setTitle("Paid", for: .normal)
        } else {
            self.paidButton.setTitle("Pay", for: .normal)
        }
        paidButton.addTarget(self, action: #selector(paidButtonTapped), for: .touchUpInside)
    }
    
    @objc func paidButtonTapped() {
        delegate?.paidButtonTapped(sender: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(billNameLabel)
        self.contentView.addSubview(amountDueLabel)
        self.contentView.addSubview(dueDateLabel)
        self.contentView.addSubview(paidButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        billNameLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        billNameLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 2.0).isActive = true
        billNameLabel.bottomAnchor.constraint(equalTo: self.dueDateLabel.topAnchor).isActive = true
        billNameLabel.trailingAnchor.constraint(equalTo: self.amountDueLabel.leadingAnchor).isActive = true
        
        amountDueLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        amountDueLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        paidButton.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        paidButton.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        paidButton.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        paidButton.leadingAnchor.constraint(equalTo: self.amountDueLabel.trailingAnchor).isActive = true
        paidButton.widthAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.3).isActive = true
        
        dueDateLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
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
        label.font = UIFont(name: Constants.universalFont, size: 24)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Constants.grayMainColor
        return label
    }()
    
    let amountDueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 40)
        label.textAlignment = .center
        label.textColor = Constants.blueMainColor
        label.adjustsFontSizeToFitWidth = true
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
        button.layer.cornerRadius = 5
        button.contentMode = .scaleAspectFit
        return button
    }()
}

protocol BillCellDelegate: class {
    func paidButtonTapped(sender: BillTableViewCell)
}
