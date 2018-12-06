//
//  Utilities.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/5/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import Foundation

class Utilities {
    
    static func convertToDateFrom(string: String, debug: Bool)-> Date? {
        let formatter = DateFormatter()
        if ( debug ) { print("\ndate string: \(string)") }
        let dateS = string
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if let date:Date = formatter.date(from: dateS) {
            if ( debug ) { print("Convertion to Date: \(date)\n") }
            return date
        } else {
            return formatter.date(from: "1900/01/01")
        }
    }
    
    static func convertToStringNoTimeFrom(date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }

    static func  getWeekDay(myDate: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([ .weekday ], from: myDate)
        return dateComponents.day!
    }
    
    static func calcGrossProfit(profit: Double, Commision: Double) -> Double {
        return profit 
    }
    
    static func dollarValue(forDouble: Double) -> String {
        let formattedDouble = String(format: "%.0f", locale: Locale.current, Double(forDouble))
        return  "$\(formattedDouble)"
    }
    
}
