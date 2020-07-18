//
//  Route.swift
//  FerryTimeTable3
//
//  Created by b123400 on 2020/07/03.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

enum Island: String, Codable {
    case centralCheungChau = "central-cheungchau"
    case centralMuiWo = "central-muiwo"
    case centralPengChau = "central-pengchau"
    case centralYungShueWan = "central-yungshuewan"
    case centralSokKwuWan = "central-sokkwuwan"
    case northPointHungHom = "northpoint-hunghom"
    case northPointKowloonCity  = "northpoint-kowlooncity"
    case pengChauHeiLingChau = "pengchau-heilingchau"
    case aberdeenSokKwuWan = "aberdeen-sokkwuwan"
    case centralDiscoveryBay = "central-discoverybay"
    case maWanTsuenWan = "mawan-tsuenwawn"
    case saiWanHoKwunTong = "saiwanho-kwuntong"
    case saiWanHoSamKaTsuen = "saiwanho-samkatsuen"
    case samKaTsuenTungLungIsland = "samkatsuen-tunglungisland"
}

enum Direction: String, Codable {
    case fromPrimary = "FromPrimary"
    case toPrimary = "ToPrimary"
}

struct Route<T: Codable>: Codable {
    let island: Island
    let timetables: [Timetable<T>]
    
    func map<U>(_ transform: (T) throws -> U) rethrows -> Route<U> {
        return Route<U>(
            island: island,
            timetables: try timetables.map { try $0.map(transform) }
        )
    }
}

struct Timetable<T: Codable>: Codable {
    let direction : Direction
    let ferries: [Ferry<T>]
    let days: Set<Day>
    
    func map<U>(_ transform: (T) throws -> U) rethrows -> Timetable<U> {
        return Timetable<U>(
            direction: direction,
            ferries: try ferries.map { try $0.map(transform) },
            days: days
        )
    }
}

struct Ferry<T: Codable>: Codable {
    let time: T
    let modifiers: Set<Modifier>
    
    func map<U>(_ transform: (T) throws -> U) rethrows -> Ferry<U> {
        return Ferry<U>(
            time: try transform(self.time),
            modifiers: modifiers
        )
    }
}

enum Modifier: String, Codable {
    case fastFerry = "FastFerry"
    case slowFerry = "SlowFerry"
    case optionalFerry = "OptionalFerry"
    case freight = "Freight"
}

enum DayOfWeek: String, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

enum Day: Hashable, Codable {
    case weekday(DayOfWeek)
    case holiday
    
    init(from decoder: Decoder) throws {
        if let dayOfWeek = try? DayOfWeek.init(from: decoder) {
            self = .weekday(dayOfWeek)
            return
        }
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        if (str == "holiday") {
            self = .holiday
            return
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value is not holiday or weekday")
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .holiday:
            var container = encoder.singleValueContainer()
            return try container.encode("holiday")
        case .weekday(let dow):
            return try dow.encode(to: encoder)
        }
        
    }
}

func midnight(date: Date) -> Date {
    let cal = Calendar.init(identifier: .gregorian)
    var components = cal.dateComponents(in: TimeZone(identifier: "Asia/Hong_Kong")!, from: date)
    components.hour = 0
    components.minute = 0
    components.second = 0
    components.nanosecond = 0
    return cal.date(from: components)!
}

func timeOffsetToAbsolute(offset: Int, baseDate: Date) -> Date {
    midnight(date: baseDate).addingTimeInterval(TimeInterval(offset))
}

extension Ferry where T == Int {
    func toAbsolute(date: Date) -> Ferry<Date> {
        self.map { timeOffsetToAbsolute(offset: $0, baseDate: date) }
    }
}
