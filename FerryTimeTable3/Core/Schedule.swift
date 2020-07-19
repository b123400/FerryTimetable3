//
//  Schedule.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/18.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

class Schedule {
    let raws: [Route<Int>]
    init(raws: [Route<Int>]) {
        self.raws = raws
    }

    func upcomingFerries(island: Island, direction: Direction, count: Int) -> [Ferry<Date>] {
        upcomingFerries(date: Date(), island: island, direction: direction, count: count)
    }

    func upcomingFerries(date: Date, island: Island, direction: Direction, count: Int) -> [Ferry<Date>] {
        let timetables = routesForIsland(island: island)
            .flatMap { $0.timetables }
            .filter { $0.direction == direction }

        let yesterday = date.addingTimeInterval(-86400)
        let yesterdaysTimetable = timetables.first { $0.days.contains(dateToModelDay(date: yesterday)) }
        let yesterdaysFerries = yesterdaysTimetable.map { $0.ferries } ?? []
        let futureFerriesFromYesterday = yesterdaysFerries.map { $0.toAbsolute(date: yesterday) }.filter { $0.time >= date }

        let nextCount = count - futureFerriesFromYesterday.count
        if (nextCount == 0) {
            return futureFerriesFromYesterday
        }
        if (nextCount < 0) {
            return Array(futureFerriesFromYesterday[0..<count])
        }
        let upcoming = upcomingFerriesWithoutYesterday(date: date, island: island, direction: direction, count: nextCount)
        return futureFerriesFromYesterday + upcoming
    }

    private func upcomingFerriesWithoutYesterday(date: Date, island: Island, direction: Direction, count: Int) -> [Ferry<Date>] {
        let timetables = routesForIsland(island: island)
            .flatMap { $0.timetables }
            .filter { $0.direction == direction }

        if timetables.isEmpty {
            // Just in case, to prevent infinite loop
            return []
        }

        let todaysTimetables = timetables.first { $0.days.contains(dateToModelDay(date: date)) }
        let todaysFerries = todaysTimetables.map { $0.ferries } ?? []
        let fs = todaysFerries.map { $0.toAbsolute(date: date) }.filter { $0.time >= date }

        let nextCount = count - fs.count
        if (nextCount == 0) {
            return fs
        }
        if (nextCount < 0) {
            return Array(fs[0..<count])
        }

        let tomorrow = midnight(date: date.addingTimeInterval(86400))
        let upcoming = upcomingFerriesWithoutYesterday(date: tomorrow, island: island, direction: direction, count: nextCount)
        return fs + upcoming
    }

    private func routesForIsland(island: Island) -> [Route<Int>] {
        raws.filter { $0.island == island }
    }

    private func dateToModelDay(date: Date) -> Day {
        let cal = Calendar(identifier: .gregorian)
        let weekday = cal.component(.weekday, from: date)
        switch weekday {
        case 1:
            return .weekday(.sunday)
        case 2:
            return .weekday(.monday)
        case 3:
            return .weekday(.tuesday)
        case 4:
            return .weekday(.wednesday)
        case 5:
            return .weekday(.thursday)
        case 6:
            return .weekday(.friday)
        case 7:
            return .weekday(.saturday)
        default:
            print("Invalid weekday")
        }
        // TODO:
        return .holiday
    }
}
