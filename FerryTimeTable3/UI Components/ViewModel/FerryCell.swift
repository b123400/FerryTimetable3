//
//  TimetableCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/22.
//  Copyright © 2020 b123400. All rights reserved.
//

import Foundation
import UIKit

struct FerryCell {
    let hour: String
    let minute: String
    let timeLeft: TimeInterval?
    let color: UIColor
    
    init<T: RenderTime>(ferry: Ferry<T>) {
        hour = ferry.time.hourString
        minute = ferry.time.minuteString
        timeLeft = ferry.time.getTimeIntervalSince(Date())
        color = ferry.color
    }
}
