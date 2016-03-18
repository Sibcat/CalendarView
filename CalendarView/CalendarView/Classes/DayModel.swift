//
//  DayModel.swift
//  Pods
//
//  Created by Skvortsova E.O. on 18.03.16.
//
//

import Foundation
import SwiftMoment

class DayModel {
    var date: Moment!
    var isToday: Bool = false
    var isOtherMonth: Bool = false
    
    init (date: Moment, isToday: Bool, isOtherMonth: Bool) {
        self.date = date
        self.isOtherMonth = isOtherMonth
        self.isToday = isToday
    }
}

public extension Moment {
    
    func toNSDate() -> NSDate? {
        let epoch = moment(NSDate(timeIntervalSince1970: 0))
        let timeInterval = self.intervalSince(epoch)
        let date = NSDate(timeIntervalSince1970: timeInterval.seconds)
        return date
    }
    
    func isToday() -> Bool {
        let cal = NSCalendar.currentCalendar()
        return cal.isDateInToday(self.toNSDate()!)
    }
    
    func isOtherMonth(other: Moment) -> Bool {
        return self.month != other.month || self.year != other.year
    }
    
}