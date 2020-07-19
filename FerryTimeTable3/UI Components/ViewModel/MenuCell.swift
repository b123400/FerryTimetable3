//
//  MenuCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/19.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

struct MenuCell {
    let primaryLocation: String
    let secondaryLocation: String

    let fromPrimary1: String
    let fromPrimarySub1: String
    let fromPrimary2: String
    let fromPrimarySub2: String

    let toPrimary1: String
    let toPrimarySub1: String
    let toPrimary2: String
    let toPrimarySub2: String
    
    init(island: Island, fromFerries: [Ferry<Date>], toFerries: [Ferry<Date>]) {
        primaryLocation = island.primaryName
        secondaryLocation = island.secondaryName

        if fromFerries.count >= 1 {
            fromPrimary1 = MenuCell.timeString(fromFerries[0].time)
            fromPrimarySub1 = MenuCell.timeLeft(fromFerries[0].time)
        } else {
            fromPrimary1 = ""
            fromPrimarySub1 = ""
        }
        if fromFerries.count >= 2 {
            fromPrimary2 = MenuCell.timeString(fromFerries[1].time)
            fromPrimarySub2 = MenuCell.timeLeft(fromFerries[1].time)
        } else {
            fromPrimary2 = ""
            fromPrimarySub2 = ""
        }
        if toFerries.count >= 1 {
            toPrimary1 = MenuCell.timeString(toFerries[0].time)
            toPrimarySub1 = MenuCell.timeLeft(toFerries[0].time)
        } else {
            toPrimary1 = ""
            toPrimarySub1 = ""
        }
        if toFerries.count >= 2 {
            toPrimary2 = MenuCell.timeString(toFerries[1].time)
            toPrimarySub2 = MenuCell.timeLeft(toFerries[1].time)
        } else {
            toPrimary2 = ""
            toPrimarySub2 = ""
        }
    }
    
    private static func timeString(_ date: Date)-> String {
        "\(getHour(date)):\(getMinute(date))"
    }
    
    private static func getHour(_ date: Date) -> String {
        let x = Calendar.current.component(Calendar.Component.hour, from: date)
        if (x < 10) {
            return "0\(x)"
        }
        return String(x)
    }
    
    private static func getMinute(_ date: Date) -> String {
        let x = Calendar.current.component(Calendar.Component.minute, from: date)
        if (x < 10) {
            return "0\(x)"
        }
        return String(x)
    }
    
    private static func timeLeft(_ date: Date) -> String {
        let now = Date()
        let interval = date.timeIntervalSince(now)
        let min = interval / 60
        if (min < 1) {
            return "now"
        }
        if (min < 60) {
            return "In \(Int(min)) min"
        }
        let hour = min / 60
        if (hour < 24) {
            return "In \(Int(hour)) hours"
        }
        let day = hour / 24
        return "In \(Int(day)) days"
    }
}
