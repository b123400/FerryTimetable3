//
//  ResidenceScheduleView.swift
//  FerryTimetable3
//
//  Created by b123400 on 2021/05/30.
//  Copyright © 2021 b123400. All rights reserved.
//

import UIKit

private var titleFont: UIFont = UIFontMetrics(forTextStyle: .largeTitle)
    .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .regular))

private var subheadFont: UIFont = UIFontMetrics(forTextStyle: .subheadline)
    .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular))

class ResidenceScheduleView: UIView {
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

class ResidenceSchedulesView: UIView {
    
    public struct Model {
        let island: Island
        let direction: Direction
        let ferries: [Ferry<Date>]
    }
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }()

    var rows = [
        ResidenceScheduleView(),
        ResidenceScheduleView(),
        ResidenceScheduleView(),
        ResidenceScheduleView()
    ]

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: self.rows)
        stack.axis = .vertical
        stack.spacing = 8
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
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
