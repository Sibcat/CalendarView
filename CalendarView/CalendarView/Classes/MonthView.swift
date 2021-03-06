//
//  MonthView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/28/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import SwiftMoment


class MonthView: UIView {
    
    var model: MonthModel! {
        didSet {
            for week in weeks {
                week.removeFromSuperview()
            }
            weeks = []
            for weekModel in model.weeks {
                let week = WeekView(frame: CGRectZero)
                week.model = weekModel
                addSubview(week)
                weeks.append(week)
            }
            for label in weekLabels {
                addSubview(label)
            }
            
        }
    }
    
    var weeks: [WeekView] = []
    
    var weekLabels: [WeekLabel] = [
        WeekLabel(day: "пн"),
        WeekLabel(day: "вт"),
        WeekLabel(day: "ср"),
        WeekLabel(day: "чт"),
        WeekLabel(day: "пт"),
        WeekLabel(day: "сб"),
        WeekLabel(day: "вс"),
    ]
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        let labelHeight: CGFloat = 18
        let inset: CGFloat = 10
        for label in weekLabels {
            label.frame = CGRectMake(x, inset, bounds.size.width / 7, labelHeight)
            x = CGRectGetMaxX(label.frame)
        }
        var y: CGFloat = labelHeight + inset
        for i in 1...weeks.count {
            let week = weeks[i - 1]
            week.frame = CGRectMake(0, y, bounds.size.width, (bounds.size.height - (labelHeight + inset) - inset) / model.maxNumWeeks)
            y = CGRectGetMaxY(week.frame)
        }
    }
    
    /*func setWeeks() {
    if weeks.count > 0 {
    let numWeeks = Int(numDays / 7)
    let firstVisibleDate  = date.startOf(.Months).endOf(.Days).subtract(startsOn - 1, .Days).startOf(.Days)
    for i in 1...weeks.count {
    let firstDateOfWeek = firstVisibleDate.add(7*(i-1), .Days)
    let week = weeks[i - 1]
    week.month = date
    week.date = firstDateOfWeek
    week.hidden = i > numWeeks
    }
    }
    }*/
    
}

class WeekLabel: UILabel {
    
    init(day: String) {
        super.init(frame: CGRectZero)
        text = day
        textAlignment = .Center
        textColor = CalendarView.weekLabelTextColor
        font = UIFont.boldSystemFontOfSize(10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
