//
//  ViewController.swift
//  CalendarViewDemo
//
//  Created by Nate Armstrong on 5/7/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment

class ViewController: UIViewController {
   
    @IBOutlet weak var calendar: CalendarView!
    
    @IBAction func onNextTap(sender: AnyObject) {
        calendar.selectDate(date.add(1, .Months))
    }
    
    @IBAction func onPrevTap(sender: AnyObject) {
        calendar.selectDate(date.subtract(1, .Months))
    }
    
  var date: Moment! {
    didSet {
      title = date.format("LLLL yyyy")
    }
  }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        CalendarView.complementaryDayView = createComplemetaryView        
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    date = moment()
    CalendarView.minMonth = date
    calendar.delegate = self
  }
    
    private func createComplemetaryView(date: Moment, isOtherMonth: Bool) -> UIView? {
        let compView = UIView()
       let v = UIView(frame: CGRect(x: 10, y: 10, width: 8, height: 8))
        v.backgroundColor = UIColor.redColor()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 3
        compView.addSubview(v)
        compView.alpha = isOtherMonth ? 0.5 : 1
        return compView
    }

}

extension ViewController: CalendarViewDelegate {

  func calendarDidSelectDate(date: Moment) {
    self.date = date
  }

  func calendarDidPageToDate(date: Moment) {
    self.date = date
  }

}
