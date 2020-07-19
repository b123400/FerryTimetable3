//
//  MenuCollectionViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var primaryLocationLabel: UILabel!
//    @IBOutlet weak var secondaryLocationLabel: UILabel!

    @IBOutlet weak var fromPrimaryLabel1: UILabel!
    @IBOutlet weak var fromPrimarySubLabel1: UILabel!
    @IBOutlet weak var fromPrimaryLabel2: UILabel!
    @IBOutlet weak var fromPrimarySubLabel2: UILabel!

    @IBOutlet weak var toPrimaryLabel1: UILabel!
    @IBOutlet weak var toPrimarySubLabel1: UILabel!
    @IBOutlet weak var toPrimaryLabel2: UILabel!
    @IBOutlet weak var toPrimarySubLabel2: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        let title = UIFontMetrics(forTextStyle: .largeTitle)
        let titleFont = title.scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 34, weight: .regular))
        fromPrimaryLabel1.font = titleFont
        toPrimaryLabel1.font = titleFont

        let subhead = UIFontMetrics(forTextStyle: .subheadline)
        let subheadFont = subhead.scaledFont(for: UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular))
        fromPrimaryLabel2.font = subheadFont
        fromPrimarySubLabel1.font = subheadFont
        fromPrimarySubLabel2.font = subheadFont
        toPrimaryLabel2.font = subheadFont
        toPrimarySubLabel1.font = subheadFont
        toPrimarySubLabel2.font = subheadFont
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
