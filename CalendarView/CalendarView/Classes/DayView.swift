//
//  DayView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/28/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import SwiftMoment

let CalendarSelectedDayNotification = "CalendarSelectedDayNotification"

class DayView: UIView {
    
    var model: DayModel! {
        didSet {
            dateLabel.text = model.date.format("d")
            
            if complementaryView != nil {
                complementaryView?.removeFromSuperview()
            }
            if let comView = CalendarView.complementaryDayView(date: model.date, isOtherMonth: model.isOtherMonth) {
                complementaryView = comView
                addSubview(complementaryView!)
            }
            
            setNeedsLayout()
        }
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = CalendarView.dayFont
        self.addSubview(label)
        return label
    }()
    
    var selected: Bool = false {
        didSet {
            if selected {
                NSNotificationCenter.defaultCenter()
                    .postNotificationName(CalendarSelectedDayNotification, object: model.date.toNSDate())
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.updateView() }
        }
    }
    var complementaryView: UIView?
    var selectedLayer: CAShapeLayer?
    
    init() {
        super.init(frame: CGRectZero)
        
        let tap = UITapGestureRecognizer(target: self, action: "select")
        addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onSelected:",
            name: CalendarSelectedDayNotification,
            object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = CGRectInset(bounds, 10, 10)
        complementaryView?.frame = bounds
        
        updateView()
    }
    
    func onSelected(notification: NSNotification) {
        if let date = model.date, nsDate = notification.object as? NSDate {
            let mo = moment(nsDate)
            if mo.month != date.month || mo.day != date.day {
                selected = false
            }
        }
    }
    
    func updateView() {
        if self.selected {
            dateLabel.textColor = CalendarView.daySelectedTextColor
            dateLabel.backgroundColor = CalendarView.daySelectedBackgroundColor
            addSelectedLayer()
        } else {
            if model.isToday {
                dateLabel.textColor = CalendarView.todayTextColor
                dateLabel.backgroundColor = CalendarView.todayBackgroundColor
            } else if model.isOtherMonth {
                dateLabel.textColor = CalendarView.otherMonthTextColor
                dateLabel.backgroundColor = CalendarView.otherMonthBackgroundColor
            } else {
                self.dateLabel.textColor = CalendarView.dayTextColor
                self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
            }
            selectedLayer?.removeFromSuperlayer()
        }
        
    }
    
    func select() {
        selected = true
    }
    
    private func addSelectedLayer() {
        selectedLayer?.removeFromSuperlayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height/2),
            radius: min(frame.width, frame.height) / 2,
            startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        selectedLayer = CAShapeLayer()
        selectedLayer!.path = circlePath.CGPath
        
        selectedLayer!.fillColor = UIColor.clearColor().CGColor
        selectedLayer!.strokeColor = CalendarView.daySelectedCircleColor.CGColor
        selectedLayer!.lineWidth = 1.0
        selectedLayer?.zPosition = -1
        
        layer.addSublayer(selectedLayer!)
    }
    
}