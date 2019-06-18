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
    
    static func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = Constants.dateFormat
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }
        return Date()
    }
    
    static func addAMonthToDate(date: Date) -> Date {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: date) else { return Date() }
        return newDate
    }
}
