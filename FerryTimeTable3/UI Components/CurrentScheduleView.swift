//
//  CurrentScheduleView.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/24.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import UIKit

class CurrentScheduleView: UIView {

    lazy var primaryLocationLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }()
    
    lazy var fromPrimaryArrow: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.text = "→"
        return l
    }()

    lazy var fromPrimaryLabel1: UILabel = {
        let l = UILabel()
        l.font = titleFont
        return l
    }()
    lazy var fromPrimarySubLabel1: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        return l
    }()
    lazy var fromPrimaryColorView1: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    lazy var fromPrimaryLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textAlignment = .right
        return l
    }()
    lazy var fromPrimarySubLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        return l
    }()
    lazy var fromPrimaryColorView2: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    lazy var toPrimaryArrow: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.text = "←"
        return l
    }()

    lazy var toPrimaryLabel1: UILabel = {
        let l = UILabel()
        l.font = titleFont
        return l
    }()
    lazy var toPrimarySubLabel1: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        return l
    }()
    lazy var toPrimaryColorView1: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    lazy var toPrimaryLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textAlignment = .right
        return l
    }()
    lazy var toPrimarySubLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        return l
    }()
    lazy var toPrimaryColorView2: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    private lazy var titleFont: UIFont = {
        return UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 34, weight: .regular))
    }()
    
    private lazy var subheadFont: UIFont = {
        let subhead = UIFontMetrics(forTextStyle: .subheadline)
        return subhead.scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular))
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(primaryLocationLabel)
        self.addSubview(fromPrimaryArrow)
        self.addSubview(fromPrimaryLabel1)
        self.addSubview(fromPrimarySubLabel1)
        self.addSubview(fromPrimaryColorView1)
        self.addSubview(fromPrimaryLabel2)
        self.addSubview(fromPrimarySubLabel2)
        self.addSubview(fromPrimaryColorView2)
        self.addSubview(toPrimaryArrow)
        self.addSubview(toPrimaryLabel1)
        self.addSubview(toPrimarySubLabel1)
        self.addSubview(toPrimaryColorView1)
        self.addSubview(toPrimaryLabel2)
        self.addSubview(toPrimarySubLabel2)
        self.addSubview(toPrimaryColorView2)
        
        primaryLocationLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        fromPrimaryArrow.snp.makeConstraints { (make) in
            make.top.equalTo(primaryLocationLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
        }
        fromPrimaryLabel1.snp.makeConstraints { (make) in
            make.centerY.equalTo(fromPrimaryArrow.snp.centerY)
            make.left.equalTo(fromPrimaryArrow.snp.right).offset(8)
        }
        fromPrimarySubLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(fromPrimaryLabel1.snp.right).offset(50)
            make.centerY.equalTo(fromPrimaryLabel1.snp.centerY)
        }
        fromPrimaryColorView1.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(fromPrimaryLabel1)
            make.width.equalTo(5)
            make.left.equalTo(fromPrimaryLabel1.snp.right).offset(8)
        }
        fromPrimaryLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(fromPrimaryLabel1.snp.bottom).offset(8)
            make.right.equalTo(fromPrimaryLabel1.snp.right)
        }
        fromPrimarySubLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(fromPrimaryLabel2.snp.right).offset(50)
            make.centerY.equalTo(fromPrimaryLabel2.snp.centerY)
        }
        fromPrimaryColorView2.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(fromPrimaryLabel2)
            make.width.equalTo(5)
            make.left.equalTo(fromPrimaryLabel2.snp.right).offset(8)
        }
        toPrimaryArrow.snp.makeConstraints { (make) in
            make.top.equalTo(fromPrimarySubLabel2.snp.bottom).offset(8)
            make.left.equalToSuperview()
        }
        toPrimaryLabel1.snp.makeConstraints { (make) in
            make.centerY.equalTo(toPrimaryArrow.snp.centerY)
            make.left.equalTo(toPrimaryArrow.snp.right).offset(8)
        }
        toPrimarySubLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(toPrimaryLabel1.snp.right).offset(50)
            make.centerY.equalTo(toPrimaryLabel1.snp.centerY)
        }
        toPrimaryColorView1.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(toPrimaryLabel1)
            make.width.equalTo(5)
            make.left.equalTo(toPrimaryLabel1.snp.right).offset(8)
        }
        toPrimaryLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(toPrimaryLabel1.snp.bottom).offset(8)
            make.right.equalTo(toPrimaryLabel1.snp.right)
        }
        toPrimarySubLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(toPrimaryLabel2.snp.right).offset(50)
            make.centerY.equalTo(toPrimaryLabel2.snp.centerY)
        }
        toPrimaryColorView2.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(toPrimaryLabel2)
            make.width.equalTo(5)
            make.left.equalTo(toPrimaryLabel2.snp.right).offset(8)
        }
    }

    func apply(model: MenuCell) {
        primaryLocationLabel.text = model.primaryLocation + " ↔︎ " + model.secondaryLocation
        fromPrimaryLabel1.text = model.fromPrimary1
        fromPrimarySubLabel1.text = model.fromPrimarySub1
        fromPrimaryColorView1.backgroundColor = model.fromPrimaryColor1
        fromPrimaryLabel2.text = model.fromPrimary2
        fromPrimarySubLabel2.text = model.fromPrimarySub2
        fromPrimaryColorView2.backgroundColor = model.fromPrimaryColor2
        toPrimaryLabel1.text = model.toPrimary1
        toPrimarySubLabel1.text = model.toPrimarySub1
        toPrimaryColorView1.backgroundColor = model.toPrimaryColor1
        toPrimaryLabel2.text = model.toPrimary2
        toPrimarySubLabel2.text = model.toPrimarySub2
        toPrimaryColorView2.backgroundColor = model.toPrimaryColor2
    }
}
