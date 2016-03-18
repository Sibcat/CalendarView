//
//  CalendarContentView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/28/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import SwiftMoment

class ContentView: UIScrollView {
    
    let numMonthsLoaded = 3
    let currentPage = 1
    var months: [MonthView] = []
    var selectedDate: Moment?
    var paged = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var monthModels = [MonthModel]()
            let date = self.selectedDate ?? moment()
            self.selectedDate = date
            var currentDate = date.subtract(1, .Months)
            for _ in 1...self.numMonthsLoaded {
                monthModels.append(MonthModel(date: currentDate))
                currentDate = currentDate.add(1, .Months)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                for month in self.months {
                    month.removeFromSuperview()
                }
                self.months = []
                for model in monthModels {
                    let month = MonthView(frame: CGRectZero)
                    month.model = model
                    self.addSubview(month)
                    self.months.append(month)
                }
                self.selectVisibleDate(date.day)
                self.setNeedsLayout()
            }
        }
        
        /*for month in months {
        month.setdown()
        month.removeFromSuperview()
        }
        
        months = []
        let date = selectedDate ?? moment()
        selectedDate = date
        var currentDate = date.subtract(1, .Months)
        for _ in 1...numMonthsLoaded {
        let month = MonthView(frame: CGRectZero)
        month.date = currentDate
        addSubview(month)
        months.append(month)
        currentDate = currentDate.add(1, .Months)
        }*/
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        for month in months {
            month.frame = CGRectMake(x, 0, bounds.size.width, bounds.size.height)
            x = CGRectGetMaxX(month.frame)
        }
        contentSize = CGSizeMake(bounds.size.width * numMonthsLoaded, bounds.size.height)
    }
    
    func selectPage(page: Int) {
        if months.isEmpty { return }
        var page1FrameMatched = false
        var page2FrameMatched = false
        var page3FrameMatched = false
        var frameCurrentMatched = false
        
        let pageWidth = frame.size.width
        let pageHeight = frame.size.height
        
        let frameCurrent = CGRectMake(page * pageWidth, 0, pageWidth, pageHeight)
        let frameLeft = CGRectMake((page-1) * pageWidth, 0, pageWidth, pageHeight)
        let frameRight = CGRectMake((page+1) * pageWidth, 0, pageWidth, pageHeight)
        
        let page1 = months.first!
        let page2 = months[1]
        let page3 = months.last!
        
        if frameCurrent.origin.x == page1.frame.origin.x {
            page1FrameMatched = true
            frameCurrentMatched = true
        }
        else if frameCurrent.origin.x == page2.frame.origin.x {
            page2FrameMatched = true
            frameCurrentMatched = true
        }
        else if frameCurrent.origin.x == page3.frame.origin.x {
            page3FrameMatched = true
            frameCurrentMatched = true
        }
        
        if frameCurrentMatched {
            if page2FrameMatched {
                print("something weird happened")
            }
            else if page1FrameMatched {
                let newDate = page1.model.date.subtract(1, .Months)
                if let minDate = CalendarView.minMonth {
                    if newDate.month < (minDate.month - 1) && newDate.year <= minDate.year { return }
                }
                page3.model =  MonthModel(date: newDate)
                page1.frame = frameCurrent
                page2.frame = frameRight
                page3.frame = frameLeft
                months = [page3, page1, page2]
            }
            else if page3FrameMatched {
                page1.model = MonthModel(date: page3.model.date.add(1, .Months))
                page1.frame = frameRight
                page2.frame = frameLeft
                page3.frame = frameCurrent
                months = [page2, page3, page1]
            }
            contentOffset.x = CGRectGetWidth(frame)
            selectedDate = nil
            paged = true
        }
    }
    
    func selectDate(date: Moment) {
        if let minDate = CalendarView.minMonth {
            if date.month < minDate.month && date.year <= minDate.year { return }
        }
        selectedDate = date
        setup()
        //selectVisibleDate(date.day)
    }
    
    func selectVisibleDate(date: Int) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let month = self.currentMonth()
            for week in month.weeks {
                for day in week.days {
                    if day.model.date != nil && day.model.date.month == month.model.date.month && day.model.date.day == date {
                        day.selected = true
                        return
                    }
                }
            }
        }
    }
    
    func removeObservers() {
        for month in months {
            for week in month.weeks {
                for day in week.days {
                    NSNotificationCenter.defaultCenter().removeObserver(day)
                }
            }
        }
    }
    
    func currentMonth() -> MonthView {
        return months[1]
    }
    
}
