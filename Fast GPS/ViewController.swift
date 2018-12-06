//
//  ViewController.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/5/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Trades.deleteAll()
        if Trades.getAllTrades().count < 1 {
            CSVhelper().importCSV(debug: true)
        }
        Trades.debugAllTrades()
        print("\n-------------------------------------------------------------------------------\nTrades \(Trades.getAllTrades().count)")
        print("Largest Winner \(Utilities.dollarValue(forDouble: Trades.largestWin())) \nLargest Loss \(Utilities.dollarValue(forDouble: Trades.largestLoss()))")
        print(("Largest Week \(Utilities.dollarValue(forDouble: Trades.largestWeek()))"))
        print(("Smallest Week \(Utilities.dollarValue(forDouble: Trades.smallestWeek()))"))
        print(("Average Week \(Utilities.dollarValue(forDouble: Trades.averageWeek()))"))
        print("Net Profit \(Utilities.dollarValue(forDouble: Trades.totalProfit()))")
        print("Swap \(Utilities.dollarValue(forDouble: Trades.totalSwap()))")
        print("Gross Profit \(Utilities.dollarValue(forDouble: Trades.totalProfit() + Trades.totalSwap()))")
        let income = (Trades.totalProfit() + Trades.totalSwap()) / 3
        print("Montly income  \(Utilities.dollarValue(forDouble: income))")
        print("Roi \(String(format: "%.2f", Trades.totalRoi()))%")
        print("-------------------------------------------------------------------------------")
    }


}



