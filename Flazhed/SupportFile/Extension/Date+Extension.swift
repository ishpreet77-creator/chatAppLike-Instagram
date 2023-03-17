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
    var timeAgoStory: String {
        return getTimeAgoSinceNow(type: kStory)
    }

    private func getTimeAgoSinceNow(type:String=kProfile) -> String {
        
        debugPrint("getTimeAgoSinceNow = \(self)")
        var ago = ""
        
        var difference = Calendar.current.dateComponents([.month,.weekOfMonth,.day,.hour, .minute,.second], from: Date(), to:  self)
        if type == kStory
        {
            difference = Calendar.current.dateComponents([.month,.weekOfMonth,.day,.hour, .minute,.second], from: self, to:  Date())
            ago = " ago"
        }
        else
        {
            difference = Calendar.current.dateComponents([.month,.weekOfMonth,.day,.hour, .minute,.second], from: Date(), to:  self)
            ago = ""
        }

        var interval = difference.year ?? 0//Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        
        if interval > 0 {
            return (interval == 1 ? "\(interval)" + " year" : "\(interval)" + " years") + ago
        }

        interval = difference.month ?? 0// Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return (interval == 1 ? "\(interval)" + " month" : "\(interval)" + " months") + ago
        }

        interval = difference.day ?? 0//Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        
        debugPrint("Time interval day = \(interval)")
        
        if interval > 0 {
            return (interval == 1 ? "\(interval)" + " day" : "\(interval)" + " days") + ago
        }

        interval = difference.hour ?? 0//Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return (interval == 1 ? "\(interval)" + " hour" : "\(interval)" + " hours") + ago
        }

        interval = difference.minute ?? 0//Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return (interval == 1 ? "\(interval)" + " minute" : "\(interval)" + " minutes") + ago
        }

        return "a moment ago"
    }
}

enum TimeZoneType {
    case utc
    case gmt
    case local
}

// MARK: Enumerations

enum DateFormat: String {
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case dateTime12 = "yyyy-MM-dd hh:mm:ss"
    case dateTime12Sec = "yyyy-MM-dd hh:mm"
    case dateTime24 = "yyyy-MM-dd HH:mm"
    case date12HourTime = "yyyy-MM-dd h:mm a"
    case mdytimeDate = "MM-dd-yyyy h:mm a"
    case mdyDate = "MM-dd-yyyy"
    case ymdDate = "yyyy-MM-dd"
    case dmyDate = "dd-MM-yyyy"
    case shortMDYDate = "MMM dd, yyyy"
    case longMDYDate = "MMMM dd, yyyy"
    case longdateTime = "MMMM dd yyyy @ h:mm a"
    case longDMYData = "EEEE dd MMM yyyy"
    case daydm = "EEE dd MMM"
    case time = "h:mm a"
    case longTime = "HH:mm:ss"
    case longTime12 = "hh:mm:ss"
    case weekDay = "EEE"
    case date = "dd"
    case ymDate = "YYYY-MM"
    case localTime = "hh:mm a"
    case iso = "yyyy-MM-dd'T'HH:mm:ss+HH:mm"
    case NewISO = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    case StoryDateFormat = "dd MMMM, yyyy"
    case longdateTime2 = "EEEE dd MMMM yyyy"
    case newsimpledate = "YYYY-MM-dd"
    case DOBFormat = "dd/M/yyyy"
    
    
}


extension Date{
    
    func string(format: DateFormat, type: TimeZoneType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if type == .utc {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        else if type == .gmt {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            
        }
        else {
            dateFormatter.timeZone =  TimeZone.ReferenceType.default
        }
        return dateFormatter.string(from: self)
    }
    
    
    
}
extension String {
    
    func dateFromString(format: DateFormat, type: TimeZoneType) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if type == .utc {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        else if type == .gmt {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            
        }
        else {
            dateFormatter.timeZone =  TimeZone.ReferenceType.default
        }
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func dateFromString2(format: DateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self) ?? Date()
    }
}


extension String{
    
    var numberOfWords: Int {
        let inputRange = CFRangeMake(0, utf16.count)
        let flag = UInt(kCFStringTokenizerUnitWord)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, self as CFString, inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var count = 0
        
        while tokenType != [] {
            count += 1
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return count
    }
    
    func utcToLocalTime(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
       // 2021-03-05T13:13:00.000Z
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//"H:mm:ss"
      // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
          // dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func utcToLocalDate(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
       // 2021-03-05T13:13:00.000Z
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//"H:mm:ss"
      //  dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
          //  dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func checkTimeDiffrent(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
      //  let endOfMonth = Calendar.current.date(byAdding: .hour, value: 0, to: enteredDate) ?? Date()
        let now = Date()
      
        let diffComponents = Calendar.current.dateComponents([.minute], from: enteredDate, to: now)
        guard let hours = diffComponents.minute else { return 0 }
      //  let minutes = diffComponents.minute
        
        
//        if (endOfMonth < now)
//        {
//            debugPrint("Expired - \(enteredDate) - \(endOfMonth)")
//        }
//        else
//        {
//            // valid
//            debugPrint("valid - now: \(now) entered: \(enteredDate)")
//        }
        return hours
    }
    func checkHoursTimeDiffrent(startTime:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .hour, value: kTimeRing48, to: enteredDate) ?? Date()
        return endOfMonth.timeAgoSinceNow

    }
    func checkTimeAgo(startTime:String) -> String
    {
        
        //2022-02-09T06:11:05.409Z
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
       // let endOfMonth = Calendar.current.date(byAdding: .day, value: 1000, to: enteredDate) ?? Date()
        return enteredDate.timeAgoStory
        

    }
    
    func checkHoursTimeDiffrent2(startTime:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .hour, value: kTimeRing48, to: enteredDate) ?? Date()
        return endOfMonth.timeAgoSinceNow
        /*
        let now = Date()
      
        let difference = Calendar.current.dateComponents([.hour, .minute,.second], from: now, to: endOfMonth)
        
        let seconds = "\(difference.second ?? 0)"
        var minutes = ""
        let min = (difference.minute ?? 0)
        if min>1
        {
            minutes = "\(difference.minute ?? 0) minutes" + " "
        }
        else
        {
             minutes = "\(difference.minute ?? 0) minute" + " "
        }
        
        var hours = ""
        let hr = (difference.hour ?? 0)
        
        if hr>1
        {
            hours = "\(difference.hour ?? 0) hours" + " " + minutes
        }
        else
        {
            hours = "\(difference.hour ?? 0) hour" + " " + minutes
        }
        
        var days = ""
        
        let day = (difference.day ?? 0)
        if day>1
        {
            days = "\(difference.day ?? 0) days" + " " + hours
        }
        else
        {
            days = "\(difference.day ?? 0) day" + " " + hours
        }

               if let day = difference.day, day          > 0 { return days }
               if let hour = difference.hour, hour       > 0 { return hours }
               if let minute = difference.minute, minute > 0 { return minutes }
               if let second = difference.second, second > 0 { return seconds }
               return ""
        
        */
        
    }
    
    
    func checkHoursLeftForRing(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .minute, value: kTimeRing, to: enteredDate) ?? Date()
        let now = Date()
      
        let difference = Calendar.current.dateComponents([.minute], from: now, to: endOfMonth)


        
        let hr = (difference.minute ?? 0)
        
        if let hour = difference.minute, hour       > 0 { return hr }

               return 0

    }
    func checkHoursLeftForRing24Hr(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        
        
//        let endOfMonth = Calendar.current.date(byAdding: .minute, value: kTimeRing24, to: enteredDate) ?? Date()
        let now = Date()
      
        let difference = Calendar.current.dateComponents([.minute], from: enteredDate, to: now)


        
        let hr = (difference.minute ?? 0)
        
        if let hour = difference.minute, hour       > 0 { return hr }

               return 0

    }
    func checkHoursLeftForRing48Hr(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        
        
//        let endOfMonth = Calendar.current.date(byAdding: .minute, value: kTimeRing24, to: enteredDate) ?? Date()
        let now = Date()
      
        let difference = Calendar.current.dateComponents([.minute], from: enteredDate, to: now)


        
        let hr = (difference.minute ?? 0)
        
        if let hour = difference.minute, hour > 0 { return hr }

               return 0

    }
    
    func checkHoursLeftNoReply(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .minute, value: kTimeLeft48, to: enteredDate) ?? Date() //kTimeLeft48
        let now = Date()
      
        let difference = Calendar.current.dateComponents([.minute], from: now, to: endOfMonth)


        
        let hr = (difference.minute ?? 0)
        
        if let hour = difference.minute, hour       > 0 { return hr }

               return 0

    }
    
    func checkHoursRemaining(startTime:String) -> (Int, Int, Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .day, value: 3, to: enteredDate) ?? Date() //kTimeLeft48
        let now = Date()
        
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: endOfMonth)


        
        let hr = (difference.hour ?? 0)
        let min = difference.minute ?? 0
        let sec = difference.second ?? 0
        
        return(hr, min, sec)
        
        
      
//        let difference = Calendar.current.dateComponents([.minute], from: now, to: endOfMonth)
//
//
//
//        let hr = (difference.minute ?? 0)
//
//        if let hour = difference.minute, hour       > 0 { return hr }
    }
    
    func checkMinutesRemaining(startTime:String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let enteredDate = dateFormatter.date(from: startTime) ?? Date()
        let endOfMonth = Calendar.current.date(byAdding: .day, value: 0, to: enteredDate) ?? Date() //kTimeLeft48
        let now = Date()
        
        let difference = Calendar.current.dateComponents([.minute], from: now, to: endOfMonth)


        
        let mn = (difference.minute ?? 0)
        
        if let minute = difference.minute, minute > 0 {
            return mn
            
        }

        
        
      
//        let difference = Calendar.current.dateComponents([.minute], from: now, to: endOfMonth)
//
//
//
//        let hr = (difference.minute ?? 0)
//
//        if let hour = difference.minute, hour       > 0 { return hr }

               return 0

    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {

    func formatRelativeString() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.doesRelativeDateFormatting = true

        if calendar.isDateInToday(self) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else if calendar.isDateInYesterday(self){
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        } else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return dateFormatter.weekdaySymbols[weekday-1]
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }

        return dateFormatter.string(from: self)
    }
}
extension Date {
    func CurrentTimeString(format: String="h:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone.current
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
