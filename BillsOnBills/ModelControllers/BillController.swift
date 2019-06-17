//
//  BillController.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation
import CoreData

class BillController {
    static let shared = BillController()
    let newBillAdded = Notification.Name("newBillAdded")
    
    init() {
        self.bills = fetchBills()
    }
    
    func addBill(name: String, amountDue: Float, dueDate: Date) {
        let _ = Bill(name: name, amountDue: amountDue, dueDate: dueDate)
        saveToPersistentStorage()
        self.bills = fetchBills()
        NotificationCenter.default.post(name: newBillAdded, object: nil)
        NSLog("Notification posted \(newBillAdded)")
        print("Saved Bill Successfully")
    }
    
    func deleteBill(bill: Bill) {
        bill.managedObjectContext?.delete(bill)
        saveToPersistentStorage()
        self.bills = fetchBills()
        print("Deleted Bill")
    }
    
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
    
    var bills: [Bill] = []
}
