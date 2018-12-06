//
//  GraphView.swift
//  Fast GPS
//
//  Created by Warren Hansen on 12/6/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit

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

private extension CGFloat {
    static let graphLineWidth: CGFloat = 1.0
    static let scale: CGFloat = 0.015
    static let lineViewHeightMultiplier: CGFloat = 0.7
    static let baseLineWidth: CGFloat = 1.0
    static let timeStampPadding: CGFloat = 10.0
}

final class GraphView: UIView {
    
    private var dataPoints: ChartData
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    private var lineView = UIView()
    private let timeStampLabel = UILabel()
    private var lineViewLeading = NSLayoutConstraint()
    private var timeStampLeading = NSLayoutConstraint()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private var step: CGFloat = 1
    private var xCoordinates: [CGFloat] = []
    
    init(data: ChartData) {
        self.dataPoints = data
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        height = rect.size.height
        width = rect.size.width
        step = width/CGFloat(dataPoints.data.count)
        print("width \(width) height \(height) step \(step)")
        drawGraph()
        //drawMiddleLine()
        configureLineIndicatorView()
        configureTimeStampLabel()
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(userDidPan(_:)))
    }
    
    private func drawGraph() {
        // draw graph
        
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: 0, y: height))
        
        for i in stride(from: 0, to: width, by: step) {
            xCoordinates.append(i)
        }
        
        for (index, dataPoint) in dataPoints.data.enumerated() {
            print("\(index) \t\(dataPoint.price) \(dataPoints.openingPrice)")
            let midPoint = dataPoints.openingPrice
            let graphMiddle = height * 0.85
            
            let y: CGFloat =  graphMiddle + CGFloat(midPoint - dataPoint.price) * .scale
            
            let newPoint = CGPoint(x: xCoordinates[index], y: y)
            graphPath.addLine(to: newPoint)
        }
        
        UIColor.upAccentColor.setFill()
        UIColor.upAccentColor.setStroke()
        graphPath.lineWidth = .graphLineWidth
        graphPath.stroke()
    }
    
    private func configureLineIndicatorView() {
        lineView.backgroundColor = UIColor.gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        lineViewLeading = NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        addConstraints([
            lineViewLeading,
            NSLayoutConstraint(item: lineView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0),
            NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height * .lineViewHeightMultiplier),
            ])
    }
    
    private func configureTimeStampLabel() {
        timeStampLabel.configureTitleLabel(withText: "MAY 25")
        timeStampLabel.textColor = .lightTitleTextColor
        addSubview(timeStampLabel)
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeStampLeading = NSLayoutConstraint(item: timeStampLabel, attribute: .leading, relatedBy: .equal, toItem: lineView, attribute: .leading, multiplier: 1.0, constant: .timeStampPadding)
        
        addConstraints([
            NSLayoutConstraint(item: timeStampLabel, attribute: .bottom, relatedBy: .equal, toItem: lineView, attribute: .top, multiplier: 1.0, constant: 0.0),
            timeStampLeading
            ])
    }
    
    @objc func userDidPan(_ pgr: UIPanGestureRecognizer) {
        let touchLocation = pgr.location(in: self)
        
        switch pgr.state {
        case .changed, .began, .ended:
            let x = convertTouchLocationToPointX(touchLocation: touchLocation)
            
            guard let xIndex = xCoordinates.index(of: x) else { return }
            
            let dataPoint = dataPoints.data[xIndex]
            
            updateIndicator(with: x, date: dataPoint.date)
            
        default: break
        }
    }
    
    private func convertTouchLocationToPointX(touchLocation: CGPoint) -> CGFloat {
        
        let maxX: CGFloat = width
        let minX: CGFloat = 0
        
        var x = min(max(touchLocation.x, maxX), minX)
        
        xCoordinates.forEach { (xCoordinate) in
            let difference = abs(xCoordinate - touchLocation.x)
            if difference <= step {
                x = CGFloat(xCoordinate)
                return
            }
        }
        
        return x
    }
    
    private func updateIndicator(with offset: CGFloat, date: Date) {
        
        timeStampLabel.text = dateFormatter.string(from: date).uppercased()
        lineViewLeading.constant = offset
    }
}

extension UIColor {
    static let upAccentColor: UIColor = UIColor(red: 0.19, green: 0.8, blue: 0.6, alpha: 1.0)
    static let downAccentColor: UIColor = UIColor(red: 0.95, green: 0.34, blue: 0.23, alpha: 1.0)
    
    static let lightTextTextColor: UIColor = .white
    static let darkTextTextColor: UIColor = .black
    
    static let lightTitleTextColor: UIColor = .gray
    static let darkTitleTextColor: UIColor = .gray
}

extension CGFloat {
    static let titleTextSize: CGFloat = 12.0
    static let textTextSize: CGFloat = 24.0
    static let linkTextSize: CGFloat = 12.0
}

extension UILabel {
    
    func configureTitleLabel(withText text: String) {
        configure(withText: text.uppercased(), size: .titleTextSize, alignment: .left, lines: 0, robotoWeight: .medium)
    }
    
    func configureTextLabel(withText text: String) {
        configure(withText: text, size: .textTextSize, alignment: .left, lines: 0, robotoWeight: .regular)
    }
    
    func configureLinkLabel(withText text: String) {
        configure(withText: text.uppercased(), size: .linkTextSize, alignment: .left, lines: 0, robotoWeight: .medium)
    }
    
    private func configure(withText newText: String,
                           size: CGFloat,
                           alignment: NSTextAlignment,
                           lines: Int,
                           robotoWeight: RobotoWeight) {
        text = newText
        font = UIFont(name: robotoWeight.rawValue, size: size)
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
    }
}

enum RobotoWeight: String {
    case thin = "Roboto-Thin"
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
    case bold = "Roboto-Bold"
}
