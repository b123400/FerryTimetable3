//
//  MenuCollectionViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class MenuCollectionViewCell: UICollectionViewCell {

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
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    lazy var fromPrimarySubLabel1: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .subheadline)
        l.textColor = UIColor.secondaryLabel
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    lazy var fromPrimaryLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textAlignment = .right
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    lazy var fromPrimarySubLabel2: UILabel = {
        let l = UILabel()
        l.font = subheadFont
        l.textColor = UIColor.secondaryLabel
        l.adjustsFontSizeToFitWidth = true
        return l
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
    
    private lazy var titleFont: UIFont = {
        return UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 34, weight: .regular))
    }()
    
    private lazy var subheadFont: UIFont = {
        let subhead = UIFontMetrics(forTextStyle: .subheadline)
        return subhead.scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular))
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(primaryLocationLabel)
        self.contentView.addSubview(fromPrimaryArrow)
        self.contentView.addSubview(fromPrimaryLabel1)
        self.contentView.addSubview(fromPrimarySubLabel1)
        self.contentView.addSubview(fromPrimaryLabel2)
        self.contentView.addSubview(fromPrimarySubLabel2)
        self.contentView.addSubview(toPrimaryArrow)
        self.contentView.addSubview(toPrimaryLabel1)
        self.contentView.addSubview(toPrimarySubLabel1)
        self.contentView.addSubview(toPrimaryLabel2)
        self.contentView.addSubview(toPrimarySubLabel2)
        
        primaryLocationLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview()//.offset(8)
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
        fromPrimaryLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(fromPrimarySubLabel1.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(fromPrimaryLabel1.snp.right)
        }
        fromPrimarySubLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(fromPrimaryLabel2.snp.right).offset(50)
            make.centerY.equalTo(fromPrimaryLabel2.snp.centerY)
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
        toPrimaryLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(toPrimarySubLabel1.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(toPrimaryLabel1.snp.right)
        }
        toPrimarySubLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(toPrimaryLabel2.snp.right).offset(50)
            make.centerY.equalTo(toPrimaryLabel2.snp.centerY)
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

//        let title = UIFontMetrics(forTextStyle: .largeTitle)
//        let titleFont = title.scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 34, weight: .regular))
//        fromPrimaryLabel1.font = titleFont
//        toPrimaryLabel1.font = titleFont

//        fromPrimaryLabel2.font = subheadFont
//        fromPrimarySubLabel1.font = subheadFont
//        fromPrimarySubLabel2.font = subheadFont
//        toPrimaryLabel2.font = subheadFont
//        toPrimarySubLabel1.font = subheadFont
//        toPrimarySubLabel2.font = subheadFont
    }

    func apply(model: MenuCell) {
        primaryLocationLabel.text = model.primaryLocation + " ↔︎ " + model.secondaryLocation
        fromPrimaryLabel1.text = model.fromPrimary1
        fromPrimarySubLabel1.text = model.fromPrimarySub1
        fromPrimaryLabel2.text = model.fromPrimary2
        fromPrimarySubLabel2.text = model.fromPrimarySub2
        toPrimaryLabel1.text = model.toPrimary1
        toPrimarySubLabel1.text = model.toPrimarySub1
        toPrimaryLabel2.text = model.toPrimary2
        toPrimarySubLabel2.text = model.toPrimarySub2
    }
}
