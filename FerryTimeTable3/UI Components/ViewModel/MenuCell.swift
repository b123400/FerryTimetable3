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
            fromPrimary1 = MenuCell.timeString(f.time)
            fromPrimarySub1 = MenuCell.timeLeft(f.time)
            fromPrimaryColor1 = f.color
        } else {
            fromPrimary1 = ""
            fromPrimarySub1 = ""
            fromPrimaryColor1 = .clear
        }
        if fromFerries.count >= 2 {
            let f = fromFerries[1]
            fromPrimary2 = MenuCell.timeString(f.time)
            fromPrimarySub2 = MenuCell.timeLeft(f.time)
            fromPrimaryColor2 = f.color
        } else {
            fromPrimary2 = ""
            fromPrimarySub2 = ""
            fromPrimaryColor2 = .clear
        }
        if toFerries.count >= 1 {
            let f = toFerries[0]
            toPrimary1 = MenuCell.timeString(f.time)
            toPrimarySub1 = MenuCell.timeLeft(f.time)
            toPrimaryColor1 = f.color
        } else {
            toPrimary1 = ""
            toPrimarySub1 = ""
            toPrimaryColor1 = .clear
        }
        if toFerries.count >= 2 {
            let f = toFerries[1]
            toPrimary2 = MenuCell.timeString(f.time)
            toPrimarySub2 = MenuCell.timeLeft(f.time)
            toPrimaryColor2 = f.color
        } else {
            toPrimary2 = ""
            toPrimarySub2 = ""
            toPrimaryColor2 = .clear
        }
    }
    
    private static func timeString(_ date: Date)-> String {
        "\(getHour(date)):\(getMinute(date))"
    }
    
    private static func getHour(_ date: Date) -> String {
        let x = Calendar.current.component(Calendar.Component.hour, from: date)
        if x < 10 {
            return "0\(x)"
        }
        return String(x)
    }
    
    private static func getMinute(_ date: Date) -> String {
        let x = Calendar.current.component(Calendar.Component.minute, from: date)
        if x < 10 {
            return "0\(x)"
        }
        return String(x)
    }
    
    private static func timeLeft(_ date: Date) -> String {
        let now = Date()
        let interval = date.timeIntervalSince(now)
        let min = interval / 60
        if min < 1 {
            return "now"
        }
        if min < 60 {
            return "In \(Int(min)) min"
        }
        let hour = min / 60
        if hour < 24 {
            return "In \(Int(hour)) hours"
        }
        let day = hour / 24
        return "In \(Int(day)) days"
    }
}
