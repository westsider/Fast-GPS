//
//  Chart Data.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/7/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import Foundation

struct ChartData {
    let openingPrice: Double
    let data: [(date: Date, price: Double)]
    
    static var portfolioData: ChartData {
        let chartData: [(date: Date, price: Double)]  = Trades.graphData()
        let startPrice: Double = chartData.first?.price ?? 100.0
        let portfolioData = ChartData(openingPrice: startPrice, data: chartData)
        return portfolioData
    }
}
