//
//  MenuCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/19.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import UIKit

struct MenuCell {
    let primaryLocation: String
    let secondaryLocation: String

    let fromPrimary1: String
    let fromPrimarySub1: String
    let fromPrimaryColor1: UIColor
    let fromPrimary2: String
    let fromPrimarySub2: String
    let fromPrimaryColor2: UIColor

    let toPrimary1: String
    let toPrimarySub1: String
    let toPrimaryColor1: UIColor
    let toPrimary2: String
    let toPrimarySub2: String
    let toPrimaryColor2: UIColor
    
    init(island: Island, fromFerries: [Ferry<Date>], toFerries: [Ferry<Date>]) {
        primaryLocation = island.primaryName
        secondaryLocation = island.secondaryName

        if fromFerries.count >= 1 {
            let f = fromFerries[0]
            fromPrimary1 = f.time.timeString
            fromPrimarySub1 = timeLeft(date: f.time)
            fromPrimaryColor1 = f.color
        } else {
            fromPrimary1 = ""
            fromPrimarySub1 = ""
            fromPrimaryColor1 = .clear
        }
        if fromFerries.count >= 2 {
            let f = fromFerries[1]
            fromPrimary2 = f.time.timeString
            fromPrimarySub2 = timeLeft(date: f.time)
            fromPrimaryColor2 = f.color
        } else {
            fromPrimary2 = ""
            fromPrimarySub2 = ""
            fromPrimaryColor2 = .clear
        }
        if toFerries.count >= 1 {
            let f = toFerries[0]
            toPrimary1 = f.time.timeString
            toPrimarySub1 = timeLeft(date: f.time)
            toPrimaryColor1 = f.color
        } else {
            toPrimary1 = ""
            toPrimarySub1 = ""
            toPrimaryColor1 = .clear
        }
        if toFerries.count >= 2 {
            let f = toFerries[1]
            toPrimary2 = f.time.timeString
            toPrimarySub2 = timeLeft(date: f.time)
            toPrimaryColor2 = f.color
        } else {
            toPrimary2 = ""
            toPrimarySub2 = ""
            toPrimaryColor2 = .clear
        }
    }
}
