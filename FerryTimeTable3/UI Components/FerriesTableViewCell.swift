//
//  TimetableViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/22.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class FerriesTableViewCell: UITableViewCell {
    
    var timeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFontMetrics(forTextStyle: UIFont.TextStyle.body).scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 26, weight: .regular))
        return l
    }()
    var subLabel: UILabel = {
        let l = UILabel()
        l.font = UIFontMetrics(forTextStyle: UIFont.TextStyle.caption1).scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular))
        return l
    }()
    
    var colorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(subLabel)
        self.contentView.addSubview(colorView)
        
        colorView.snp.makeConstraints { (make) in
            make.width.equalTo(5)
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(colorView.snp.right).offset(8)
        }
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.centerX).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func apply(model: FerryCell) {
        timeLabel.text = "\(model.hour):\(model.minute)"
        let intervalLeft = model.timeLeft
        if let t = intervalLeft, t < 60 * 60 * 3 {
            // within 3 hours
            subLabel.text = timeLeft(interval: t)
        } else {
            subLabel.text = ""
        }
        colorView.backgroundColor = model.color
        if model.color == .clear {
            colorView.snp.updateConstraints { (make) in
                make.width.equalTo(0)
                make.left.equalToSuperview().offset(12)
            }
        } else {
            colorView.snp.updateConstraints { (make) in
                make.width.equalTo(5)
                make.left.equalToSuperview().offset(20)
            }
        }
    }

}
