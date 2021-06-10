//
//  ResidentSchedulesView.swift
//  Ferry widget
//
//  Created by b123400 on 2021/06/06.
//  Copyright © 2021 b123400. All rights reserved.
//

import Foundation
import UIKit

private var titleFont: UIFont = UIFontMetrics(forTextStyle: .largeTitle)
    .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 26, weight: .regular))

private var subheadFont: UIFont = UIFontMetrics(forTextStyle: .subheadline)
    .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular))

class WidgetResidenceScheduleView: UIView {
    lazy var label: UILabel = {
        let l = UILabel()
        l.font = titleFont
        return l
    }()
    lazy var subLabel: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        return l
    }()
    lazy var colorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.label)
        self.addSubview(self.subLabel)
        self.addSubview(self.colorView)

        label.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right).offset(50)
            make.centerY.equalTo(label.snp.centerY)
        }
        colorView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(label)
            make.width.equalTo(5)
            make.left.equalTo(label.snp.right).offset(8)
        }
    }
}

class WidgetResidenceSchedulesView: UIView {
    
    public struct Model {
        let island: Island
        let direction: Direction
        let ferries: [Ferry<Date>]
    }
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.font = titleFont
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }()
    
    lazy var count: Int = 4 {
        didSet {
            rows = [0..<count].map { _ in
                WidgetResidenceScheduleView()
            }
        }
    }

    var rows = [
        WidgetResidenceScheduleView(),
        WidgetResidenceScheduleView(),
        WidgetResidenceScheduleView(),
        WidgetResidenceScheduleView()
    ]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(8)
        }
        
        let stack = UIStackView(arrangedSubviews: self.rows)
        stack.axis = .vertical
        stack.spacing = 8
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
        }
    }
    
    func apply(model: Model) {
        label.text = model.island.nameForDirection(direction: model.direction)
        for i in 0..<rows.count {
            if i < model.ferries.count {
                let row = rows[i]
                let ferry = model.ferries[i]
                row.label.text = ferry.time.timeString
                row.subLabel.text = timeLeft(date: ferry.time)
                row.colorView.backgroundColor = ferry.color
            }
        }
    }
}
