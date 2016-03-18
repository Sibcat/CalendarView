//
//  WeekModel.swift
//  Pods
//
//  Created by Skvortsova E.O. on 18.03.16.
//
//

import Foundation
import SwiftMoment

class WeekModel {
    let date: Moment!
    var days: [DayModel]!
    let month: Moment!
    var hidden: Bool = false
    
    init(withDate: Moment, andMonth: Moment) {
        date = withDate
        month = andMonth
        days = []
        for i in 0...7 {
                let dayDate = date.add(i, .Days)
                let day = DayModel(date: dayDate,
                isToday: dayDate.isToday(),
                isOtherMonth: month.isOtherMonth(dayDate))
                days.append(day)
            }
        }
    }
