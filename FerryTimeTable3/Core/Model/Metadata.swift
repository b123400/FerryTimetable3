//
//  Metadata.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/11/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

struct Metadata: Codable {
    let fares: [Fare]
    let durations: [Duration]
}

struct Fare: Codable {
    let passenger: String
    let days: Set<Day>
    let fare: Double
    let type: FareType
    let modifiers: [FareModifier]
}

enum FareType: String, Codable, CaseIterable {
    case slowFerryOrdinaryClass = "SlowFerryOrdinaryClass"
    case slowFerryDeluxeClass = "SlowFerryDeluxeClass"
    case fastFerry = "FastFerry"
}

enum FareModifier: String, Codable, CaseIterable {
    case fromSecondaryOnly = "FromSecondaryOnly"
}

struct Duration: Codable {
    let ferryType: Optional<Modifier>
    let duration: TimeInterval
}

func isFareTypeOfModifier(fareType: FareType, modifier: Modifier) -> Bool {
    switch fareType {
    case .fastFerry:
        return modifier == Modifier.fastFerry
    case .slowFerryDeluxeClass, .slowFerryOrdinaryClass:
        return modifier == Modifier.slowFerry
    }
    return false
}

func filterMetadataWithDate(metadata: Metadata, date: Date) -> Metadata {
    let day = Schedule.dateToModelDay(date: date)
    let filteredFares = metadata.fares.filter { (fare) -> Bool in
        fare.days.contains(day)
    }
    return Metadata(fares: filteredFares, durations: metadata.durations)
}

func filterMetadataWithFerry<T>(metadata: Metadata, ferry: Ferry<T>) -> Metadata {
    let theDuration = metadata.durations.first { (duration) -> Bool in
        if let modifier = duration.ferryType, ferry.modifiers.contains(modifier) {
            return true
        }
        return false
    }
    let defaultDuration = metadata.durations.first { (duration) -> Bool in
        duration.ferryType == nil
    }
    let filteredDurations: [Duration]
    if let d = theDuration {
        filteredDurations = [d]
    } else if let d = defaultDuration {
        filteredDurations = [d]
    } else {
        filteredDurations = []
    }

    let filteredFares = metadata.fares.filter { (fare) -> Bool in
        let speed = ferry.modifiers.first { $0 == .fastFerry || $0 == .slowFerry }
        let typeMatch: Bool
        if let s = speed {
            typeMatch = isFareTypeOfModifier(fareType: fare.type, modifier: s)
        } else {
            typeMatch = true
        }
        return typeMatch
    }
    return Metadata(fares: filteredFares, durations: filteredDurations)
}

func filterMetadata(metadata: Metadata, ferry: Ferry<Date>) -> Metadata {
    return filterMetadata(metadata: metadata, date: ferry.time, ferry: ferry)
}

func filterMetadata<T>(metadata: Metadata, date: Date, ferry: Ferry<T>) -> Metadata {
    return filterMetadataWithDate(
        metadata: filterMetadataWithFerry(metadata: metadata, ferry: ferry),
        date: date
    )
}


