//
//  WeekView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import SwiftMoment

class WeekView: UIView {

    var model: WeekModel! {
        didSet {
            days = []
            for dayModel in model.days {
                let day = DayView()
                day.model = dayModel
                addSubview(day)
                days.append(day)
            }
        }
    }
    
  var days: [DayView] = []

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  func setdown() {
    for day in days {
      NSNotificationCenter.defaultCenter().removeObserver(day)
      day.removeFromSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    var x: CGFloat = 0
    for i in 1...days.count {
      let day = days[i - 1]
      day.frame = CGRectMake(x, 0, bounds.size.width / days.count, bounds.size.height)
      x = CGRectGetMaxX(day.frame)
    }
  }

}
