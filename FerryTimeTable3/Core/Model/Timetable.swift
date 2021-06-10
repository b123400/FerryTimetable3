//
//  Route.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/03.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum Island: String, Codable, CaseIterable, Identifiable, CodingKey {
    var id: String { rawValue }
    
    case centralCheungChau = "central-cheungchau"
    case centralMuiWo = "central-muiwo"
    case centralPengChau = "central-pengchau"
    case centralYungShueWan = "central-yungshuewan"
    case centralSokKwuWan = "central-sokkwuwan"
    case centralMaWan = "central-mawan"
    case northPointHungHom = "northpoint-hunghom"
    case northPointKowloonCity  = "northpoint-kowlooncity"
    case pengChauHeiLingChau = "pengchau-heilingchau"
    case aberdeenSokKwuWan = "aberdeen-sokkwuwan"
    case centralDiscoveryBay = "central-discoverybay"
    case maWanTsuenWan = "mawan-tsuenwawn"
    case saiWanHoKwunTong = "saiwanho-kwuntong"
    case saiWanHoSamKaTsuen = "saiwanho-samkatsuen"
    case samKaTsuenTungLungIsland = "samkatsuen-tunglungisland"
    
    var fullName: String {
        self.primaryName + " ↔︎ " + self.secondaryName
    }
    
    var primaryName: String {
        switch self {
        case .centralCheungChau: fallthrough
        case .centralMuiWo: fallthrough
        case .centralPengChau: fallthrough
        case .centralYungShueWan: fallthrough
        case .centralSokKwuWan: fallthrough
        case .centralMaWan: fallthrough
        case .centralDiscoveryBay:
            return NSLocalizedString("Central", comment: "")
        case .northPointHungHom: fallthrough
        case .northPointKowloonCity:
            return NSLocalizedString("North Point", comment: "")
        case .pengChauHeiLingChau:
            return NSLocalizedString("Peng Chau", comment: "")
        case .aberdeenSokKwuWan:
            return NSLocalizedString("Aberdeen", comment: "")
        case .maWanTsuenWan:
            return NSLocalizedString("Ma Wan", comment: "")
        case .saiWanHoKwunTong: fallthrough
        case .saiWanHoSamKaTsuen:
            return NSLocalizedString("Sai Wan Ho", comment: "")
        case .samKaTsuenTungLungIsland:
            return NSLocalizedString("Sam Ka Tsuen", comment: "")
        }
    }
    var secondaryName: String {
        switch self {
        case .centralCheungChau:
            return NSLocalizedString("Cheung Chau", comment: "")
        case .centralMuiWo:
            return NSLocalizedString("Mui Wo", comment: "")
        case .centralPengChau:
            return NSLocalizedString("Peng Chau", comment: "")
        case .centralYungShueWan:
            return NSLocalizedString("Yung Shue Wan", comment: "")
        case .centralSokKwuWan: fallthrough
        case .aberdeenSokKwuWan:
            return NSLocalizedString("Sok Kwu Wan", comment: "")
        case .centralMaWan:
            return NSLocalizedString("Ma Wan", comment: "")
        case .centralDiscoveryBay:
            return NSLocalizedString("Discovery Bay", comment: "")
        case .northPointHungHom:
            return NSLocalizedString("Hung Hom", comment: "")
        case .northPointKowloonCity:
            return NSLocalizedString("Kowloon City", comment: "")
        case .pengChauHeiLingChau:
            return NSLocalizedString("Hei Ling Chau", comment: "")
        case .maWanTsuenWan:
            return NSLocalizedString("Tsuen Wan", comment: "")
        case .saiWanHoKwunTong:
            return NSLocalizedString("Kwun Tong", comment: "")
        case .saiWanHoSamKaTsuen:
            return NSLocalizedString("Sam Ka Tsuen", comment: "")
        case .samKaTsuenTungLungIsland:
            return NSLocalizedString("Tung Lung Island", comment: "")
        }
    }
    
    func nameForDirection(direction: Direction) -> String {
        switch direction {
        case .fromPrimary:
            return self.primaryName + "→" + self.secondaryName
        case .toPrimary:
            return self.primaryName + "←" + self.secondaryName
        }
    }
    
    static func toKeyedDict<T>(strDict: [String: T]) -> [Island: T] {
        var dict: [Island: T] = [:]
        for (key, value) in strDict {
            if let i = Island(stringValue: key) {
                dict[i] = value
            }
        }
        return dict
    }
    
    static func fromKeyedDict<T>(dict: [Island: T]) -> [String: T] {
        var strDict: [String: T] = [:]
        for (key, value) in dict {
            strDict[key.rawValue] = value
        }
        return strDict
    }
}

enum Residence: String, Codable, CaseIterable, Identifiable, CodingKey {
    var id: String { rawValue }

    case cheungChau = "central-cheungchau"
    case muiWo = "central-muiwo"
    case pengChau = "central-pengchau"
    case yungShueWan = "central-yungshuewan"
    case sokKwuWan = "central-sokkwuwan"
    case centralMaWan = "central-mawan"
    case discoveryBay = "central-discoverybay"
    case maWanTsuenWan = "mawan-tsuenwawn"
    
    init?(island: Island) {
        switch island {
        case .centralCheungChau:
            self = .cheungChau
        case .centralMuiWo:
            self = .muiWo
        case .centralPengChau:
            self = .pengChau
        case .centralYungShueWan:
            self = .yungShueWan
        case .centralSokKwuWan:
            self = .sokKwuWan
        case .centralMaWan:
            self = .centralMaWan
        case .centralDiscoveryBay:
            self = .discoveryBay
        case .maWanTsuenWan:
            self = .maWanTsuenWan
        default:
            return nil
        }
    }
    
    var region: CLCircularRegion {
        switch self {
        case .cheungChau:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.2096247, longitude: 114.0204817),
                                    radius: CLLocationDistance(2000),
                                    identifier: "cheungChau")
        case .muiWo:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.2656168, longitude: 113.9850852),
                                    radius: CLLocationDistance(2000),
                                    identifier: "muiWo")
        case .pengChau:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.285715, longitude: 114.039798),
                                    radius: CLLocationDistance(1000),
                                    identifier: "pengChau")
        case .yungShueWan:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.205635, longitude: 114.124731),
                                    radius: CLLocationDistance(3500),
                                    identifier: "yungShueWan")
        case .sokKwuWan:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.205635, longitude: 114.124731),
                                    radius: CLLocationDistance(3500),
                                    identifier: "sokKwuWan")
        case .centralMaWan:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.349398, longitude: 114.059617),
                                    radius: CLLocationDistance(1000),
                                    identifier: "centralMaWan")
        case .discoveryBay:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.291232, longitude: 114.014930),
                                    radius: CLLocationDistance(3500),
                                    identifier: "discoveryBay")
        case .maWanTsuenWan:
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.349398, longitude: 114.059617),
                                    radius: CLLocationDistance(1000),
                                    identifier: "maWanTsuenWan")
        }
    }
    var regionIsPrimary: Bool {
        switch self {
        case .maWanTsuenWan:
            return true
        default:
            return false
        }
    }
    var island: Island {
        switch self {
        case .cheungChau:
            return .centralCheungChau
        case .muiWo:
            return .centralMuiWo
        case .pengChau:
            return .centralPengChau
        case .yungShueWan:
            return .centralYungShueWan
        case .sokKwuWan:
            return .centralSokKwuWan
        case .centralMaWan:
            return .centralMaWan
        case .discoveryBay:
            return .centralDiscoveryBay
        case .maWanTsuenWan:
            return .maWanTsuenWan
        }
    }
    var name: String {
        switch self {
        case .maWanTsuenWan: fallthrough
        case .centralMaWan:
            return self.island.fullName
        default:
            return self.island.secondaryName
        }
    }
}

enum Direction: String, Codable {
    case fromPrimary = "FromPrimary"
    case toPrimary = "ToPrimary"
}

struct Route<T> {
    let island: Island
    let timetables: [Timetable<T>]

    func map<U>(_ transform: (T) throws -> U) rethrows -> Route<U> {
        return Route<U>(
            island: island,
            timetables: try timetables.map { try $0.map(transform) }
        )
    }
}

struct Timetable<T> {
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

struct Ferry<T> {
    let time: T
    let modifiers: Set<Modifier>

    func map<U>(_ transform: (T) throws -> U) rethrows -> Ferry<U> {
        return Ferry<U>(
            time: try transform(self.time),
            modifiers: modifiers
        )
    }
    
    var color: UIColor {
        if modifiers.contains(.optionalFerry) {
            return .systemYellow
        }
        if modifiers.contains(.fastFerry) {
            return UIColor.systemRed
        }
        if modifiers.contains(.slowFerry) {
            return UIColor.systemGreen
        }
        return .clear
    }
}

extension Ferry: Codable where T: Codable {}
extension Timetable: Codable where T: Codable {}
extension Route: Codable where T: Codable {}

enum Modifier: String, Codable, Equatable {
    case fastFerry = "FastFerry"
    case slowFerry = "SlowFerry"
    case optionalFerry = "OptionalFerry"
    case freight = "Freight"
    
    func toString() -> String {
        switch self {
        case .fastFerry:
            return NSLocalizedString("Fast Ferry", comment: "")
        case .slowFerry:
            return NSLocalizedString("Slow Ferry", comment: "")
        case .optionalFerry:
            return NSLocalizedString("Optional Ferry", comment: "")
        case .freight:
            return NSLocalizedString("Freight", comment: "")
        }
    }
    
    func toAttributedString() -> NSAttributedString {
        switch self {
        case .fastFerry:
            return NSAttributedString(string: self.toString(),
                                      attributes: [.backgroundColor : UIColor.systemRed,
                                                   .foregroundColor: UIColor.white
                                      ])
        case .slowFerry:
            return NSAttributedString(string: self.toString(),
                                      attributes: [.backgroundColor : UIColor.systemGreen,
                                                   .foregroundColor: UIColor.white
                                      ])
        case .optionalFerry:
            return NSAttributedString(string: self.toString(),
                                      attributes: [.backgroundColor : UIColor.systemYellow,
                                                   .foregroundColor: UIColor.white
                                      ])
        case .freight:
            return NSAttributedString(string: self.toString())
        }
    }
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
        if str == "holiday" {
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
    let cal = Calendar(identifier: .gregorian)
    var components = cal.dateComponents(in: TimeZone(identifier: "Asia/Hong_Kong")!, from: date)
    components.hour = 0
    components.minute = 0
    components.second = 0
    components.nanosecond = 0
    return cal.date(from: components)!
}

func timeOffsetToAbsolute(offset: TimeInterval, baseDate: Date) -> Date {
    let x = midnight(date: baseDate)
    return x.addingTimeInterval(offset)
}

extension Ferry where T == TimeInterval {
    func toAbsolute(date: Date) -> Ferry<Date> {
        self.map { timeOffsetToAbsolute(offset: $0, baseDate: date) }
    }
}

protocol RenderTime {
    var hourString: String { get }
    var minuteString: String { get }
    func getTimeIntervalSince(_ date: Date) -> TimeInterval?
}

extension Date: RenderTime {
    var hourString: String {
        let cal = Calendar(identifier: .gregorian)
        let components = cal.dateComponents(in: TimeZone(identifier: "Asia/Hong_Kong")!, from: self)
        return String(format: "%02d", components.hour ?? 0)
    }
    var minuteString: String {
        let cal = Calendar(identifier: .gregorian)
        let components = cal.dateComponents(in: TimeZone(identifier: "Asia/Hong_Kong")!, from: self)
        return String(format: "%02d", components.minute ?? 0)
    }
    var timeString: String {
        "\(self.hourString):\(self.minuteString)"
    }
    func getTimeIntervalSince(_ date: Date) -> TimeInterval? {
        self.timeIntervalSince(date)
    }
}

extension TimeInterval: RenderTime {
    var hourString: String {
        return String(format: "%02d", Int(self/60/60))
    }
    var minuteString: String {
        let min = self / 60
        return String(format: "%02d", Int(min) % 60)
    }
    func getTimeIntervalSince(_ date: Date) -> TimeInterval? {
        .none
    }
}

func timeLeft(date: Date) -> String {
    let now = Date()
    let interval = date.timeIntervalSince(now)
    return timeLeft(interval: interval)
}
func timeLeft(interval: TimeInterval) -> String {
    let min = interval / 60
    if min < 0 {
        return ""
    }
    if min < 1 {
        return NSLocalizedString("Now", comment: "")
    }
    if min < 60 {
        // TODO use stringsdict
        return String(format: NSLocalizedString("In %d mins", comment: ""), Int(min))
    }
    let hour = min / 60
    if hour < 24 {
        return String(format: NSLocalizedString("In %d hours", comment: ""), Int(hour))
    }
    let day = hour / 24
    return String(format: NSLocalizedString("In %d days", comment: ""), Int(day))
}
