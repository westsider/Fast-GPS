//
//  Trades.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/5/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import Foundation
import RealmSwift

class Trades: Object {
    
    @objc dynamic var ticker: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var week:Int = 0
    @objc dynamic var commision: Double = 0.00
    @objc dynamic var profit: Double = 0.00
    @objc dynamic var swap: Double = 0.00
    
    class func deleteAll() {
        let realm = try! Realm()
        let allPlaces = realm.objects(Trades.self)
        try! realm.write({
            realm.delete(allPlaces)
        })
    }
    
    class func getAllTrades()-> Results<Trades> {
        let realm = try! Realm()
        let allTrades = realm.objects(Trades.self)
        let sortDate = allTrades.sorted(byKeyPath: "date", ascending: true)
        return sortDate
    }
    
    class func addTrade(ticker:String, date:Date, week: Int, comm: Double, swap:Double, profit: Double) {
        
        let realm = try! Realm()
        let trades = Trades()
        trades.ticker = ticker
        trades.date = date
        trades.week = week
        trades.commision = comm
        trades.swap = swap
        trades.profit = profit
        
        try! realm.write {
            realm.add(trades)
        }
    }
    
    class func debugAllTrades() {
        let allTrades = getAllTrades()
        for trade in allTrades {
            print("\(Utilities.convertToStringNoTimeFrom(date: trade.date)) \tweek \(trade.week) \t\(trade.ticker) \tcomm \(trade.commision) \tswap \(trade.swap) \tprofit \(trade.profit)")
        }
    }
    
    static func largestWin() -> Double {
        let allTrades = getAllTrades()
        let allProfit = allTrades.map { $0.profit + $0.commision}
        return allProfit.max() ?? 0.0
    }
    
    static func largestLoss() -> Double {
        let allTrades = getAllTrades()
        let allProfit = allTrades.map { $0.profit + $0.commision}
        return allProfit.min() ?? 0.0
    }
    
    static func totalSwap() -> Double {
        let allTrades = getAllTrades()
        let allProfit = allTrades.map { $0.swap }
        return allProfit.reduce( 0, +)
    }
    
    static func totalProfit() -> Double {
        let allTrades = getAllTrades()
        let allProfit = allTrades.map { $0.profit + $0.commision }
        return allProfit.reduce( 0, +)
    }
    
    static func totalRoi() -> Double {
        return (( totalProfit() + totalSwap() ) / 50000.00) * 100
    }
    
    static func weeksFound() -> [Int] {
        let allTrades = getAllTrades()
        let weeks: [Int] = allTrades.map { (week: Trades) in
            return week.week
        }
        return weeks.removingDuplicates()
    }
    
    static func sumByWeek() -> [Double] {
        var weekArray: [Double] = []
        let allTrades = getAllTrades()
        for id in weeksFound()  {
            let oneWeek = allTrades.filter("week == %@", id)
            let profits: [Double] = oneWeek.map { (profit: Trades) in
                return profit.profit
            }
            let sum = profits.reduce(0, +)
            weekArray.append(sum)
        }
        return weekArray
    }
    
    static func largestWeek() -> Double {
        let largest = sumByWeek()
        return largest.max() ?? 999999.09
    }
    
    static func smallestWeek() -> Double {
        let small = sumByWeek()
        return small.min() ?? -999999.09
    }
    
    static func averageWeek() -> Double {
        let all = sumByWeek()
        let sum = all.reduce(0, +)
        return sum / Double(all.count)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
