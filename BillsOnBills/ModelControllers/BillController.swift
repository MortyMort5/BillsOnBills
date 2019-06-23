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
        self.checkBillDates()
    }
    
    // MARK: - C.R.U.D
    
    func addBill(name: String, amountDue: Float, dueDate: Date) {
        let bill = Bill(name: name, amountDue: amountDue, dueDate: dueDate)
        saveToPersistentStore()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
        //        self.appDelegate?.scheduleNotification(forBill: bill)
        print("Saved Bill Successfully")
    }
    
    func deleteBill(bill: Bill) {
        let request: NSFetchRequest<Bill> = Bill.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", bill.name ?? "")
        
        do {
            let bills = try Stack.context.fetch(request)
            let bill = bills[0] as NSManagedObject
            Stack.context.delete(bill)
            self.saveToPersistentStore()
            print("Deleted Bill")
        } catch let error {
            print("Error deleting bill : \(error.localizedDescription)")
        }
    }
    
    func updateBill(bill: Bill) {
        saveToPersistentStore()
        print("Updated Bill Successfully")
    }
    
    // MARK: - Find the Sum Functions
    
    func sumOfBills() -> String {
        let totalAmount = self.bills.reduce(0, { $0 + $1.amountDue})
        return "Total: \(String(format: "$%.02f", totalAmount))"
    }
    
    func sumOfBillsUnpaid() -> String {
        var totalMonthlyAmount: Float = 0
        for bill in self.bills {
            if !bill.isPaid {
                totalMonthlyAmount = totalMonthlyAmount + bill.amountDue
            }
        }
        return String(format: "$%.02f", totalMonthlyAmount)
    }
    
    func sumOfBillsPaid() -> String {
        var totalMonthlyAmount: Float = 0
        for bill in self.bills {
            if bill.isPaid {
                totalMonthlyAmount = totalMonthlyAmount + bill.amountDue
            }
        }
        return String(format: "$%.02f", totalMonthlyAmount)
    }
    
    // MARK: - Date Modifier Functions
    
    func checkBillDates() {
        for bill in self.bills {
            if bill.dueDate! < Date() && !Calendar.current.isDate(bill.dueDate!, inSameDayAs: Date())  {
                bill.dueDate = self.updateDateOfBill(bill: bill)
                self.updateBill(bill: bill)
            }
        }
    }
    
    func updateDateOfBill(bill: Bill) -> Date {
        var flag = false
        while !flag {
            if bill.dueDate! < Date() && !Calendar.current.isDate(bill.dueDate!, inSameDayAs: Date())  {
                bill.dueDate = StaticFunctions.addAMonthToDate(date: bill.dueDate!)
            } else {
                flag = true
            }
        }
        return bill.dueDate!
    }
    
    // MARK: - Helper Functions
    
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
    
    // MARK: - Computed Properties
    
    var groupedBills: [[Bill]] {
        let request: NSFetchRequest<Bill> = Bill.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        let bills = (try? Stack.context.fetch(request)) ?? []
        
        let groupDictionary = Dictionary(grouping: bills) { (bill) -> Bool in
            return bill.isPaid
        }
        
        var groupedBills = [[Bill]]()
        let keys = groupDictionary.keys.sorted(by: {!$0 && $1})
        
        keys.forEach { (key) in
            groupedBills.append(groupDictionary[key]!)
        }
        
        return groupedBills
    }
    
    var bills: [Bill] {
        let request: NSFetchRequest<Bill> = Bill.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let shared = BillController()
    let newBillAdded = Notification.Name("newBillAdded")
}
