//
//  CSV Helper.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/5/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import Foundation

class CSVhelper {
    func importCSV(debug: Bool) {
        var ticker: String = ""
        var tradeDate: Date = Date()
        var week: Int = 0
        var commision:Double = 0
        var profit: Double = 0
        var swap: Double = 0.00
        var totalTrades: Int = 0
        
        if let path = Bundle.main.path(forResource: "Profit", ofType: "txt"){
            var csvLine = ""
            do {
                let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                let lines : [String] = contents.components(separatedBy: "\n")
                
                var lineCounter = 0
                
                
                for each in lines {
                    
                    // date
                    if lineCounter == 1 {
                        let stringDate = each.replacingOccurrences(of: ".", with: "/")
                        if let date = Utilities.convertToDateFrom(string: stringDate, debug: false) {
                            week = NSCalendar.current.component(.weekOfYear, from: date)
                            tradeDate = date
                        }
                        csvLine.append("\(tradeDate)")
                        csvLine.append(", ")
                        
                    }
                    // ticker
                    if lineCounter == 4 {
                        let trunc: String = String(each.dropLast())
                        csvLine.append(trunc.uppercased())
                        csvLine.append(", ")
                        ticker = trunc.uppercased()
                    }
                    // commision
                    if lineCounter == 10 {
                        let answer = each.replacingOccurrences(of: " ", with: "")
                        csvLine.append(answer)
                        csvLine.append(", ")
                        if let commisions = Double(answer) {
                            commision = commisions
                        }
                    }
                    
                    // swap
                    if lineCounter == 12 {
                        let answer = each.replacingOccurrences(of: " ", with: "")
                        csvLine.append(answer)
                        csvLine.append(", ")
                        if answer.first == "-" {
                            let neg:String = String(answer.dropFirst())
                            swap =  Double(neg) ?? 999999999999999.3
                            swap  = swap * -1
                            print("Got Swap of \(answer) and a double of \(swap)")
                        } else {
                            swap =  Double(answer) ?? 100000000000.3
                        }
                    }
                    
                    // profit
                    if lineCounter == 13 {
                        let answer = each.replacingOccurrences(of: " ", with: "")
                        csvLine.append(answer)
                        csvLine.append("\n")
                        if answer.first == "-" {
                            let neg:String = String(answer.dropFirst())
                            profit =  Double(neg) ?? 999999999999999.3
                            profit  = profit * -1
                        } else {
                            profit =  Double(answer) ?? 100000000000.3
                        }
                    }
                    
                    lineCounter += 1
                    
                    if lineCounter == 14 {
                        lineCounter = 0
                        totalTrades += 1
                        Trades.addTrade(ticker: ticker, date: tradeDate, week: week, comm: commision, swap: swap, profit: profit)
                        profit = 0.00
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            if debug {print(csvLine)}
        }
        print("\(totalTrades) csv trades\n")
    }
}
