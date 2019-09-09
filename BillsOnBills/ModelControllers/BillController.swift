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
        checkLoginDateForUser()
        checkWhichBillsArePaid()
    }
    
    // MARK: - Manage User
    
    func addUser() {
        let _ = User(lastLoggedInDate: StaticFunctions.getCurrentDate())
        saveToPersistentStore()
        print("Created User")
    }
    
    func updateUser(user: User) {
        user.lastLoggedInDate = StaticFunctions.getCurrentDate()
        saveToPersistentStore()
        print("Updated User")
    }
    
    func checkLoginDateForUser() {
        if let user = self.user {
            if let lastDate = user.lastLoggedInDate {
                if !lastDate.isInSameMonth(date: Date()) {
                    // new month since logged in last
                    // update users lastLoggedInDate property
                    self.updateUser(user: user)
                    // update all the bills dates to this month
                    self.updateBillDates()
                }
            } else {
                // no last logged in Date
                self.updateUser(user: user)
            }
        } else {
            // no User
            self.addUser()
        }
    }
    
    // MARK: - C.R.U.D
    
    func addBill(name: String, amountDue: Float, dueDate: Date, autoPay: Bool) {
        let bill = Bill(name: name, amountDue: amountDue, dueDate: dueDate, isAutoPay: autoPay)
        saveToPersistentStore()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
        self.appDelegate?.scheduleNotification(forBill: bill)
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
    
    func checkWhichBillsArePaid() {
        for bill in self.bills {
            if bill.dueDate!.isInThePast && bill.isAutoPay {
                bill.isPaid = true
            }
        }
        self.saveToPersistentStore()
    }
    
    func updateBill(bill: Bill) {
        saveToPersistentStore()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
        print("Updated Bill Successfully")
    }
    
    // MARK: - Find the Sum Functions
    
    func sumOfBills() -> String {
        let totalAmount = self.bills.reduce(0, { $0 + $1.amountDue})
        return "Total: \n\(StaticFunctions.currencyFormatter(currency: totalAmount))"
    }
    
    func sumOfBillsUnpaid() -> String {
        var totalMonthlyAmount: Float = 0
        for bill in self.bills {
            if !bill.isPaid {
                totalMonthlyAmount = totalMonthlyAmount + bill.amountDue
            }
        }
        return StaticFunctions.currencyFormatter(currency: totalMonthlyAmount)
    }
    
    func sumOfBillsPaid() -> String {
        var totalMonthlyAmount: Float = 0
        for bill in self.bills {
            if bill.isPaid {
                totalMonthlyAmount = totalMonthlyAmount + bill.amountDue
            }
        }
        return StaticFunctions.currencyFormatter(currency: totalMonthlyAmount)
    }
    
    // MARK: - Date Modifier Functions
    
    func updateBillDates() {
        for bill in self.bills {
            bill.dueDate = self.updateDate(date: bill.dueDate!)
            bill.isPaid = false
        }
        self.saveToPersistentStore()
    }
    
    func updateDate(date: Date) -> Date {
        let oldMonth = Calendar.current.component(.month, from: date) // 6
        let newMonth = Calendar.current.component(.month, from: Date()) // 8
        
        let oldYear = Calendar.current.component(.year, from: date)
        let newYear = Calendar.current.component(.year, from: Date())
        
        var dateComp = DateComponents()
        dateComp.day = 0
        dateComp.month = newMonth - oldMonth
        dateComp.year = newYear - oldYear
        
        guard let newDate = Calendar.current.date(byAdding: dateComp, to: date) else { return Date() }
        
        return newDate
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
        return (try? Stack.context.fetch(request)) ?? []
    }
    
    var user: User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let users = (try? Stack.context.fetch(request)) ?? []
        guard let user = users.first else { return nil }
        return user
    }
    
    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let shared = BillController()
    let newBillAdded = Notification.Name("newBillAdded")
}
