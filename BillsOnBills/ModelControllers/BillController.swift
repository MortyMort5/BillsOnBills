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
//    init() {
//        self.bills = fetchBills()
//    }
    
    func sumOfBills() -> String {
        let totalAmount = self.bills.reduce(0, { $0 + $1.amountDue})
        return String(format: "$%.02f", totalAmount)
    }
    
    func sumOfBillsForTheMonth() -> String {
        var totalMonthlyAmount: Float = 0
        for bill in self.bills {
            if bill.isPaid {
                totalMonthlyAmount = totalMonthlyAmount + bill.amountDue
            }
        }
        return String(format: "$%.02f", totalMonthlyAmount)
    }
    
    func checkandUpdateDates() {
        for bill in self.bills {
            if bill.dueDate! < Date() && !Calendar.current.isDate(bill.dueDate!, inSameDayAs: Date())  {
                bill.dueDate = StaticFunctions.addAMonthToDate(date: bill.dueDate!)
                BillController.shared.updateBill(bill: bill)
            }
        }
    }
    
    func addBill(name: String, amountDue: Float, dueDate: Date) {
        let bill = Bill(name: name, amountDue: amountDue, dueDate: dueDate)
        saveToPersistentStore()
//        self.bills = fetchBills()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
//        self.appDelegate?.scheduleNotification(forBill: bill)
        print("Saved Bill Successfully")
    }
    
    func deleteBill(bill: Bill, index: Int) {
        bill.managedObjectContext?.delete(bill)
        saveToPersistentStore()
        print("Deleted Bill")
    }
    
    func updateBill(bill: Bill) {
        saveToPersistentStore()
//        self.bills = fetchBills()
        print("Updated Bill Successfully")
    }
    
    func togglePaidBill(bill: Bill) {
        bill.isPaid = !bill.isPaid
        saveToPersistentStore()
    }
    
    // MARK: - Private Functions
    
    private func saveToPersistentStore() {
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
    
    var bills: [Bill] {
        let request: NSFetchRequest<Bill> = Bill.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let shared = BillController()
    let newBillAdded = Notification.Name("newBillAdded")
}
