//
//  StaticFunctions.swift
//  BillsOnBills
//
//  Created by Sterling Mortensen on 6/13/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation

class StaticFunctions {
    static func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        let myString = formatter.string(from: date)
        return myString
    }
}
