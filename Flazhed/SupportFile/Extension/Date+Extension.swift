//
//  Date+Extension.swift
//  Flazhed
//
//  Created by IOS33 on 04/03/21.
//

import Foundation
extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }
  
  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }
  
  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}
extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}
extension Date {

    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }

    private func getTimeAgoSinceNow() -> String {
        
        let difference = Calendar.current.dateComponents([.month,.weekOfMonth,.day,.hour, .minute,.second], from: Date(), to: self)

        var interval = difference.year ?? 0//Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year" : "\(interval)" + " years"
        }

        interval = difference.month ?? 0// Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month" : "\(interval)" + " months"
        }

        interval = difference.day ?? 0//Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        
        print("Time interval day = \(interval)")
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day" : "\(interval)" + " days"
        }

        interval = difference.hour ?? 0//Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour" : "\(interval)" + " hours"
        }

        interval = difference.minute ?? 0//Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute" : "\(interval)" + " minutes"
        }

        return "a moment ago"
    }
}
