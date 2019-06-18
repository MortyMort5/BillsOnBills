//
//  BillController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import UIKit
import CoreData

class BillController {
    init() {
        self.bills = fetchBills()
    }
    
    func addBill(name: String, amountDue: Float, dueDate: Date) {
        let bill = Bill(name: name, amountDue: amountDue, dueDate: dueDate)
        saveToPersistentStorage()
        self.bills = fetchBills()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
        NSLog("Notification posted \(newBillAdded)")
        self.appDelegate?.scheduleNotification(forBill: bill)
        print("Saved Bill Successfully")
    }
    
    func deleteBill(bill: Bill) {
        bill.managedObjectContext?.delete(bill)
        saveToPersistentStorage()
        self.bills = fetchBills()
        print("Deleted Bill")
    }
    
    func updateBill(bill: Bill) {
        saveToPersistentStorage()
        self.bills = fetchBills()
        print("Updated Bill Successfully")
    }
    
    // MARK: - Private Functions
    
    private func saveToPersistentStorage() {
        do {
            try Stack.context.save()
        } catch let error {
            print("error saving persistently \(error.localizedDescription)")
        }
    }
    
    private func fetchBills() -> [Bill] {
        let request: NSFetchRequest<Bill> = Bill.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    // MARK: - Properties
    
    var bills: [Bill] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let shared = BillController()
    let newBillAdded = Notification.Name("newBillAdded")
}
