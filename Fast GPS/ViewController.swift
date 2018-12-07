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
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label11: UILabel!
    
    private var graphData = ChartData.portfolioData
    
    lazy private var graphView: GraphView = {
        return GraphView(data: graphData)
    }()
    
    lazy private var tickerControl: TickerControl = {
        return TickerControl(value: graphData.openingPrice)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Trades.deleteAll()
        if Trades.getAllTrades().count < 1 {
            CSVhelper().importCSV(debug: true)
        }
        bindData()
        setUpGraph()
    }
    
    func setUpGraph() {
        graphView.backgroundColor = .white
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delagate = self
        topView.addSubview(graphView)
        
        view.addConstraints([
            NSLayoutConstraint(item: graphView, attribute: .bottom, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: graphView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    func bindData() {
        label1.text = "\(Trades.getAllTrades().count)"
        label2.text = Utilities.dollarValue(forDouble: Trades.largestWin())
        label3.text = Utilities.dollarValue(forDouble: Trades.largestLoss())
        label4.text = Utilities.dollarValue(forDouble: Trades.largestWeek())
        label5.text = Utilities.dollarValue(forDouble: Trades.smallestWeek())
        label6.text = Utilities.dollarValue(forDouble: Trades.averageWeek())
        label7.text = Utilities.dollarValue(forDouble: Trades.totalProfit())
        label8.text = Utilities.dollarValue(forDouble: Trades.totalSwap())
        label9.text = Utilities.dollarValue(forDouble: Trades.totalProfit() + Trades.totalSwap())
        let income = (Trades.totalProfit() + Trades.totalSwap()) / 3
        label10.text = Utilities.dollarValue(forDouble: income)
        label11.text = String(format: "%.2f", Trades.totalRoi()) + " %"
    }
}

extension ViewController: GraphViewDelegate {
    func didMoveToPrice(_ graphView: GraphView, price: Double) {
        tickerControl.showNumber(price)
    }
}

