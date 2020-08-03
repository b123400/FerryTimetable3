//
//  Holiday.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/08/04.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation

struct Holiday: Codable {
    
    struct Day: Codable {
        let year: Int
        let month: Int
        let day: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            let parts = str.split(separator: "-")
            if parts.count != 3 {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid day string")
            }
            if let y = Int(parts[0]), let m = Int(parts[1]), let d = Int(parts[2]),
                m <= 12,
                d <= 31 {
                year = y
                month = m
                day = d
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid day number")
            }
            
        }
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            return try container.encode(String(format: "%d-%02d-%02d", year, month, day))
        }
        var midnight: Date {
            let dc = DateComponents(
                calendar: Calendar(identifier: .gregorian),
                timeZone: TimeZone(identifier: "Asia/Hong_Kong"),
                year: year,
                month: month,
                day: day,
                hour: 0,
                minute: 0,
                second: 0
            )
            return dc.date!
        }
    }

    let day: Day
    let name: String
}
