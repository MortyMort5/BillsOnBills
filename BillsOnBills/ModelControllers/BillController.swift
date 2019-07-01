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
        print("6")
        if let user = self.user {
            print("1")
            if let lastDate = user.lastLoggedInDate {
                print("2")
                if !lastDate.isInSameMonth(date: Date()) {
                    print("3")
                    // new month since logged in last
                    // update users lastLoggedInDate property
                    self.updateUser(user: user)
                    // update all the bills dates to this month
//                    self.updateBillDates()
                }
            } else {
                print("4")
                // no last logged in Date
                self.updateUser(user: user)
            }
        } else {
            print("5")
            // no User
            self.addUser()
        }
    }
    
    // MARK: - C.R.U.D
    
    func addBill(name: String, amountDue: Float, dueDate: Date) {
        let bill = Bill(name: name, amountDue: amountDue, dueDate: dueDate)
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
    
//    if bill.dueDate! < Date() && !Calendar.current.isDate(bill.dueDate!, inSameDayAs: Date()) && bill.isPaid  {
//    bill.dueDate = self.updateDateOfBill(bill: bill)
//    self.updateBill(bill: bill)
//    }
//    if bill.dueDate!.isInSameMonth(date: Date()) {
//
//    }
    
    func updateBillDates() {
        for bill in self.bills {
            /*
             - add months to each bill date until bill.dueDate is in the same month as Date()
             - Set all isPaid properties to false
             */
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
    
    // MARK: - Reset all Data
    
    func resetAllBillsForNewMonth() {
        /*
         - add a month to all the dates
         - change all isPaid properties to false
         */
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
