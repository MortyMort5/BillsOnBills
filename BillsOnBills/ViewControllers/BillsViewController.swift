//
//  BillsViewController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit

class BillsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BillCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(BillTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
//        tableView.separatorStyle = .singleLine
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: BillController.shared.newBillAdded, object: nil)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        self.navigationItem.title = "BILLS"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateViews() {
        totalLabel.text = BillController.shared.sumOfBills()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: totalLabel)
    }
    
    // MARK: - Table View Cell Delegate Functions
    
    func paidButtonTapped(sender: BillTableViewCell) {
        guard let bill = sender.bill else { return }
        BillController.shared.togglePaidBill(bill: bill)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BillController.shared.groupedBills.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return BillController.shared.groupedBills[section].count
        } else {
            return BillController.shared.groupedBills[section].count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BillTableViewCell else { return UITableViewCell() }
        let bill = BillController.shared.groupedBills[indexPath.section][indexPath.row]
        cell.bill = bill
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bill = BillController.shared.groupedBills[indexPath.section][indexPath.row]
            BillController.shared.deleteBill(bill: bill)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = .lightGray
        
        let sectionTitle = UILabel(frame: CGRect(x: 0, y: 5, width: headerView.bounds.size.width, height: headerView.bounds.size.height))
        sectionTitle.textAlignment = .center
        sectionTitle.font = UIFont(name: Constants.universalFont, size: 30)
        sectionTitle.textColor = Constants.grayMainColor
        
        headerView.addSubview(sectionTitle)
    
        if section == 0 {
            sectionTitle.text = "Unpaid - \(BillController.shared.sumOfBillsUnpaid())"
        } else {
            sectionTitle.text = "Paid - \(BillController.shared.sumOfBillsPaid())"
        }

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // MARK: - Target Actions
    
    @objc func addButtonTapped() {
//        AddBillView.shared.showAddBillView()
        let detailVC = BillDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Notification Center
    
    @objc func refreshData() {
        self.tableView.reloadData()
        updateViews()
    }
    
    // MARK: - Properties
    
    var modifiedBillDateFlag: Bool = false
    private var tableView: UITableView!
    
    // MARK: - UIViews
    
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
        label.font = UIFont(name: Constants.universalFont, size: 15)
        label.textColor = .black
        label.text = "$0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
