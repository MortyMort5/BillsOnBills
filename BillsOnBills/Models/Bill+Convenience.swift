//
//  MonthlyBill+Convenience.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation
import CoreData

extension Bill {
    convenience init(name: String, amountDue: Float, dueDate: Date, isPaid: Bool = false, context: NSManagedObjectContext = Stack.context) {
        self.init(context: context)
        self.name = name
        self.amountDue = amountDue
        self.dueDate = dueDate
        self.isPaid = isPaid
    }
}
