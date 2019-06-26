//
//  User+Convenience.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/25/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(lastLoggedInDate: Date, context: NSManagedObjectContext = Stack.context) {
        self.init(context: context)
        self.lastLoggedInDate = lastLoggedInDate
    }
}
