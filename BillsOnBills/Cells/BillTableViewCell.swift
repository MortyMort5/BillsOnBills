//
//  BillTableViewCell.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    
    var bill: Bill? {
        didSet {
            self.updateView()
        }
    }
    
    func updateView() {
        guard let bill = self.bill else { return }
        self.billNameLabel.text = bill.name
        self.amountDueLabel.text = String(format: "$%.02f", bill.amountDue)
        self.dueDateLabel.text = StaticFunctions.convertDateToString(date: bill.dueDate!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(billNameLabel)
        self.contentView.addSubview(amountDueLabel)
        self.contentView.addSubview(dueDateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.25
        let shadowFrame: CGRect = self.contentView.layer.bounds
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        self.contentView.layer.shadowPath = shadowPath
        
        billNameLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        billNameLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 2.0).isActive = true
        billNameLabel.bottomAnchor.constraint(equalTo: self.dueDateLabel.topAnchor).isActive = true
        billNameLabel.trailingAnchor.constraint(equalTo: self.amountDueLabel.leadingAnchor).isActive = true
        
        amountDueLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        amountDueLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        amountDueLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        amountDueLabel.widthAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.widthAnchor, multiplier: 0.3).isActive = true
        
        dueDateLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        dueDateLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        dueDateLabel.trailingAnchor.constraint(equalTo: self.amountDueLabel.leadingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let billNameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 24)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let amountDueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.universalFont, size: 40)
        label.textAlignment = .center
        label.textColor = UIColor.red
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
}
