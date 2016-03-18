//
//  MonthModel.swift
//  Pods
//
//  Created by Skvortsova E.O. on 18.03.16.
//
//

import Foundation
import SwiftMoment

class MonthModel {
    
    let maxNumWeeks = 6
    let date: Moment!
    // these values are expensive to compute so cache them
    private var numDays: Int = 30
    private  var startsOn: Int = 0
    var weeks: [WeekModel] = []
    
    init(date: Moment) {
        self.date = date
        
        startsOn = date.startOf(.Months).weekday + 6
        let numDays = Double(date.endOf(.Months).day + startsOn - 1)
        self.numDays = Int(ceil(numDays / 7.0) * 7)
        self.numDays = 42 // TODO: add option to always show 6 weeks
        
        weeks = []
        let numWeeks = Int(numDays / 7)
        for i in 0..<maxNumWeeks {
            let firstVisibleDate  = date.startOf(.Months).endOf(.Days).subtract(startsOn - 1, .Days).startOf(.Days)
            let firstDateOfWeek = firstVisibleDate.add(7*i, .Days)
            
            let week = WeekModel(withDate: firstDateOfWeek, andMonth: date)
            week.hidden = (i + 1) > numWeeks
            weeks.append(week)
        }
    }
    
    
}