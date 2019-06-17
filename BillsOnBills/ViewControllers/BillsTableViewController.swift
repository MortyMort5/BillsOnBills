//
//  BillsTableViewController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(BillTableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "moneyImage"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: BillController.shared.newBillAdded, object: nil)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        self.navigationItem.title = "BILLS"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalBillAmount = 0
        totalBillAmount = BillController.shared.bills.reduce(0, { $0 + $1.amountDue})
        totalLabel.text = String(format: "$%.02f", totalBillAmount)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: totalLabel)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return BillController.shared.bills.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BillTableViewCell else { return UITableViewCell() }
        
        let bill = BillController.shared.bills[indexPath.section]
        cell.bill = bill
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bill = BillController.shared.bills[indexPath.section]
            BillController.shared.bills.remove(at: indexPath.section)
            BillController.shared.deleteBill(bill: bill)
            
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            tableView.deleteSections(indexSet as IndexSet, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("\(section)")
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // MARK: - Target Actions
    
    @objc func addButtonTapped() {
        AddBillView.shared.showAddBillView()
    }
    
    // MARK: - Notification Center
    
    @objc func refreshData() {
        self.tableView.reloadData()
        totalBillAmount = 0
        totalBillAmount = BillController.shared.bills.reduce(0, { $0 + $1.amountDue})
        totalLabel.text = String(format: "$%.02f", totalBillAmount)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: totalLabel)
    }
    
    // MARK: - Properties
    
    var totalBillAmount: Float = 0.00
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.universalFont, size: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.universalFont, size: 20)
        label.textColor = .black
        label.text = "$0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
