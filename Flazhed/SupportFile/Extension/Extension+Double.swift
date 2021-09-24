//
//  Extension+Double.swift
//  Flazhed
//
//  Created by IOS33 on 21/07/21.
//

import Foundation
extension Double {

    func secondsToHoursMinutesSeconds () -> (Int?, Int?, Int?) {
        let hrs = self / 3600
        let mins = (self.truncatingRemainder(dividingBy: 3600)) / 60
        let seconds = (self.truncatingRemainder(dividingBy:3600)).truncatingRemainder(dividingBy:60)
        return (Int(hrs) > 0 ? Int(hrs) : nil , Int(mins) > 0 ? Int(mins) : nil, Int(seconds) > 0 ? Int(seconds) : nil)
    }

    func printSecondsToHoursMinutesSeconds () -> String {

        let time = self.secondsToHoursMinutesSeconds()

        switch time {
        case (nil, let x? , let y?):
            if x>1 && y>1
            {
                return "\(x) \(kMinutes) \(y) \(kSeconds)"
            }
            else if x>1
            {
                return "\(x) \(kMinutes) \(y) \(kSecond)"
            }
           else
            {
                return "\(x) \(kMinute) \(y) \(kSeconds)"
            }
            
        case (nil, let x?, nil):
            if x>1
            {
                return "\(x) \(kMinutes)"
            }
            else
            {
                return "\(x) \(kMinute)"
            }

        case (let x?, nil, nil):
            if x>1
            {
                return "\(x) \(kHours)"
            }
            else
            {
                return "\(x) \(kHour)"
            }

        case (nil, nil, let x?):
          
            if x>1
            {
                return "\(x) \(kSeconds)"
            }
            else
            {
                return "\(x) \(kSecond)"
            }
            
        case (let x?, nil, let z?):
          //  return "\(x) hr \(z) sec"
            if x>1 && z>1
            {
               
                return "\(x) \(kHours) \(z) \(kSeconds)"
            }
            else if z>1
            {
                return "\(z) \(kSeconds)"
            }
            else
            {
                return "\(x) \(kHour) \(z) \(kSecond)"
            }
            
        case (let x?, let y?, nil):
          //  return "\(x) hr \(y) min"
            if x>1 && y>1
            {
               
                return "\(x) \(kHours) \(y) \(kMinutes)"
            }
            else if y>1
            {
                return "\(y) \(kMinutes)"
            }
            else
            {
                return "\(x) \(kHour) \(y) \(kSecond)"
            }
            
        case (let x?, let y?, let z?):
            //return "\(x) hr \(y) min \(z) sec"
            if x>1 && y>1 && z>1
            {
               
                return "\(x) \(kHours) \(y) \(kMinutes) \(z) \(kSeconds)"
            }
            else if x>1 && y>1
            {
                return "\(x) \(kHours) \(y) \(kMinutes)"
            }
            else if y>1 && z>1
            {
                return "\(y) \(kMinutes) \(z) \(kSeconds)"
            }
            else if x>1 && z>1
            {
                return "\(x) \(kHours)  \(z) \(kSeconds)"
            }
            else
            {
                return "\(x) \(kHour) \(y) \(kMinute) \(z) \(kSecond)"
            }
        default:
            return "n/a"
        }
    }
}
