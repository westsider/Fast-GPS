//
//  ViewController.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/5/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let tickerHeightMultiplier: CGFloat = 0.4
    static let graphHeightMultiplier: CGFloat = 0.6
}

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    private var graphData = ChartData.portfolioData
    
    lazy private var graphView: GraphView = {
        return GraphView(data: graphData)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Trades.deleteAll()
        if Trades.getAllTrades().count < 1 {
            CSVhelper().importCSV(debug: true)
        }
        //Trades.debugAllTrades()
        graphView.backgroundColor = .white
        graphView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(graphView)
        
        view.addConstraints([
            NSLayoutConstraint(item: graphView, attribute: .bottom, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    func showStats() {
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



