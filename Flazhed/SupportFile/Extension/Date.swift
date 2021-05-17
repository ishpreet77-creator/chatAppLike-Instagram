//
//  Date.swift
//  Flazhed
//
//  Created by IOS32 on 11/02/21.
//
import Foundation

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
        let enteredDate = dateFormatter.date(from: startTime)!
        let endOfMonth = Calendar.current.date(byAdding: .hour, value: 0, to: enteredDate)!
        let now = Date()
      
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: enteredDate, to: now)
        guard let hours = diffComponents.hour else { return 0 }
        let minutes = diffComponents.minute
        
        
//        if (endOfMonth < now)
//        {
//            print("Expired - \(enteredDate) - \(endOfMonth)")
//        }
//        else
//        {
//            // valid
//            print("valid - now: \(now) entered: \(enteredDate)")
//        }
        return hours
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
