//
//  Route.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/03.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

enum Island: String, Codable, CaseIterable {
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
    
    var primaryName: String {
        // TODO localisation
        switch self {
        case .centralCheungChau: fallthrough
        case .centralMuiWo: fallthrough
        case .centralPengChau: fallthrough
        case .centralYungShueWan: fallthrough
        case .centralSokKwuWan: fallthrough
        case .centralDiscoveryBay:
            return "Central"
        case .northPointHungHom: fallthrough
        case .northPointKowloonCity:
            return "North Point"
        case .pengChauHeiLingChau:
            return "Peng Chau"
        case .aberdeenSokKwuWan:
            return "Aberdeen"
        case .maWanTsuenWan:
            return "Ma Wan"
        case .saiWanHoKwunTong: fallthrough
        case .saiWanHoSamKaTsuen:
            return "Sai Wan Ho"
        case .samKaTsuenTungLungIsland:
            return "Sam Ka Tsuen"
        }
    }
    var secondaryName: String {
        // TODO localisation
        switch self {
        case .centralCheungChau:
            return "Cheung Chau"
        case .centralMuiWo:
            return "Mui Wo"
        case .centralPengChau:
            return "Peng Chau"
        case .centralYungShueWan:
            return "Yung Shue Wan"
        case .centralSokKwuWan: fallthrough
        case .aberdeenSokKwuWan:
            return "Sok Kwu Wan"
        case .centralDiscoveryBay:
            return "Discovery Bay"
        case .northPointHungHom:
            return "Hung Hom"
        case .northPointKowloonCity:
            return "Kowloon City"
        case .pengChauHeiLingChau:
            return "Hei Ling Chau"
        case .maWanTsuenWan:
            return "Tsuen Wan"
        case .saiWanHoKwunTong:
            return "Kwun Tong"
        case .saiWanHoSamKaTsuen:
            return "Sam Ka Tsuen"
        case .samKaTsuenTungLungIsland:
            return "Tung Lung Island"
        }
    }
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
