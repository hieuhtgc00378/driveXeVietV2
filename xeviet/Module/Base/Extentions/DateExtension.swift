//
//  DateExtension.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}


extension String{

    var getTimeHHmm: String{
        let fmt = DateFormatter()
             fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
             if let fullDate = fmt.date(from: self){
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: fullDate)
                let minutes = calendar.component(.minute, from: fullDate)
                var hourString = "\(hour)"
                if hour < 10 { hourString = "0\(hour)" }
                var minString = "\(minutes)"
                if minutes < 10 { minString = "0\(minutes)" }

                return "\(hourString):\(minString)"
             }else{
                 return ""
             }
    }
    
//    var toDate: Date? {
//        let fmt = DateFormatter()
//        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let fullDate = fmt.date(from: self){
//            return fullDate
//        }
//    }
    
}
extension Date {
    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        return formatter
    }()
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale = .current
        return calendar
    }
    
    var toApiDateFormatString: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
//        fmt.locale = Locale(identifier: "en_US_POSIX")
//        fmt.timeZone = TimeZone(abbreviation: "JST")
        return fmt.string(from: self)
    }
    
    var toApiDateFormat: Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        return fmt.date(from: fmt.string(from: self)) ?? self
    }
    
    var toApiYearMonthFormat: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        return fmt.string(from: self)
    }
    
    var toApiDateTimeFormat: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        return fmt.string(from: self)
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 9月27日(金)
    
    
    var toHourMinSec : String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        let fullDateString = fmt.string(from: self)
        return "\(fullDateString)"
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 2020年9月
    var toJpYearDate: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/yyyy"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    var toHourMinUTC7 : String {
            // *** create calendar object ***
            var calendar = Calendar.current

            // *** define calendar components to use as well Timezone to UTC ***
            calendar.timeZone = TimeZone.current
        
            // *** Get Individual components from date ***
            let hour = calendar.component(.hour, from: self)
            let minutes = calendar.component(.minute, from: self)
        
           return "\(hour > 9 ? "\(hour)" : "0\(hour)"):\(minutes > 9 ? "\(minutes)" : "0\(minutes)")"
       }
    
    var toHourMinSecUTC7 : String {
         // *** create calendar object ***
         var calendar = Calendar.current

         // *** define calendar components to use as well Timezone to UTC ***
         calendar.timeZone = TimeZone.current
     
         // *** Get Individual components from date ***
         let hour = calendar.component(.hour, from: self)
         let minutes = calendar.component(.minute, from: self)
         let sec = calendar.component(.second, from: self)

        return "\(hour > 9 ? "\(hour)" : "0\(hour)"):\(minutes > 9 ? "\(minutes)" : "0\(minutes)"):\(sec > 9 ? "\(sec)" : "0\(sec)")"
    }
    
    var toHourMinUTC : String {
               // *** create calendar object ***
               var calendar = Calendar.current

               // *** define calendar components to use as well Timezone to UTC ***
               calendar.timeZone = TimeZone(identifier: "UTC")!
           
               // *** Get Individual components from date ***
               let hour = calendar.component(.hour, from: self)
               let minutes = calendar.component(.minute, from: self)
            return "\(hour > 9 ? "\(hour)" : "0\(hour)"):\(minutes > 9 ? "\(minutes)" : "0\(minutes)")"
          }
    
    var toFullDateUTC : String {
                // *** create calendar object ***
                var calendar = Calendar.current

                // *** define calendar components to use as well Timezone to UTC ***
                calendar.timeZone = TimeZone(identifier: "UTC")!
            
                  // *** Get Individual components from date ***
                   let hour = calendar.component(.hour, from: self)
                   let minutes = calendar.component(.minute, from: self)
                   let sec = calendar.component(.second, from: self)

                    let year = calendar.component(.year, from: self)
                    let month = calendar.component(.month, from: self)
                    let day = calendar.component(.day, from: self)
        
                  return "\(hour > 9 ? "\(hour)" : "0\(hour)"):\(minutes > 9 ? "\(minutes)" : "0\(minutes)"):\(sec > 9 ? "\(sec)" : "0\(sec)") \(day > 9 ? "\(day)" : "0\(day)")/\(month > 9 ? "\(month)" : "0\(month)")/\(year)"
           }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 2020年
    var toJpYear: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy年"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 09月
    var toJpMonth: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM月"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 15日
    var toDay: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 15日
    var toJpDay: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd日"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    /// Convert Date to String
    /// - Parameter
    /// - Returns: example 2020年9月
    var toYearMonthDay: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    var fullTimeString: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fullDateString = fmt.string(from: self)
        return fullDateString
    }
    
    var toJSTDateTimeFormat: Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        let string = fmt.string(from: self)
        return fmt.date(from: string) ?? Date()
    }
    
    func getDayOfWeek(_ today: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .japanese)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    var gregorianYear: Int {
        let com = self.calendar.dateComponents([.year], from: self)
        return com.year!
    }
    
    var gregorianMonth: Int {
        let com = self.calendar.dateComponents([.month], from: self)
        return com.month!
    }
    
    var gregorianDay: Int {
        let com = self.calendar.dateComponents([.day], from: self)
        return com.day!
    }
    
    func getGregorianDate(year: Int = 1990, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let calendar = self.calendar
        var com = DateComponents()
        com.year = year
        com.month = month
        com.day = day
        com.hour = hour
        com.minute = minute
        com.second = second
        
        return calendar.date(from: com)!
    }
    
    func getLast6Month() -> Date? {
        return self.calendar.date(byAdding: .month, value: -6, to: self)
    }
    
    func getLast3Month() -> Date? {
        return self.calendar.date(byAdding: .month, value: -3, to: self)
    }
    
    func getYesterday() -> Date? {
        return self.calendar.date(byAdding: .day, value: -1, to: self)
    }
    
    func getTomorrow() -> Date? {
        return self.calendar.date(byAdding: .day, value: 1, to: self)
    }
    
    func getLast7Day() -> Date? {
        return self.calendar.date(byAdding: .day, value: -7, to: self)
    }
    
    func getLastAnyDay(value: Int) -> Date? {
        return self.calendar.date(byAdding: .day, value: value, to: self)
    }
    
    func getLast30Day() -> Date? {
        return self.calendar.date(byAdding: .day, value: -30, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return self.calendar.date(byAdding: .month, value: -1, to: self)
    }
    
    // This week start
    func getThisWeekStart() -> Date? {
        let calendar = self.calendar
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        let firstDayOfWeek = calendar.date(from: components)
        return firstDayOfWeek
    }
    
    func getThisWeekEnd() -> Date? {
        guard let thisWeekStartDate = self.getThisWeekStart() else {
            return nil
        }
        let calender = self.calendar
        return calender.date(byAdding: .day, value: 6, to: thisWeekStartDate)
    }
    
    func getPreviousWeekStart() -> Date? {
        guard let thisWeekStartDate = self.getThisWeekStart() else {
            return nil
        }
        let calender = self.calendar
        return calender.date(byAdding: .day, value: -7, to: thisWeekStartDate)
    }
    
    func getNextWeekStart() -> Date? {
        guard let thisWeekStartDate = self.getThisWeekStart() else {
            return nil
        }
        let calender = self.calendar
        return calender.date(byAdding: .day, value: 7, to: thisWeekStartDate)
    }
    
    // This Month Start
    func getDaysInMonth() -> Int {
        let calendar = self.calendar
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func getThisMonthStart() -> Date? {
        let components = self.calendar.dateComponents([.year, .month], from: self)
        return self.calendar.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return self.calendar.date(from: components as DateComponents)!
    }
    
    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return self.calendar.date(from: components as DateComponents)!
    }
    
    // Next Month Start
    func getNextMonthStart() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        return self.calendar.date(from: components as DateComponents)!
    }
    
    // Next Month End
    
    func getNextThirdMonthEnd() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 4
        components.day = 1
        components.day -= 1
        return self.calendar.date(from: components as DateComponents)!
    }
    
    // Next Next Month Start
    func getNextNextMonthStart() -> Date? {
        let components: NSDateComponents = self.calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 2
        return self.calendar.date(from: components as DateComponents)!
    }
    
    func getSecondOrFourthSundayInMonth() -> Date? {
        let weekday = self.calendar.component(.weekday, from: self)
        let nextWeekend = self.calendar.date(byAdding: .day, value: 8 - weekday, to: self) ?? Date()
        let weekOfMonth = self.calendar.dateComponents([.weekOfMonth], from: nextWeekend).weekOfMonth
        if weekOfMonth == 1 || weekOfMonth == 3 {
            return self.calendar.date(byAdding: .day, value: 7, to: nextWeekend)
        } else if weekOfMonth == 2 || weekOfMonth == 4 {
            return nextWeekend
        } else {
            return self.calendar.date(byAdding: .day, value: 14, to: nextWeekend)
        }
    }
    
//    func toString(_ format: String) -> String {
//        PAppManager.shared.dateFormater.dateFormat = format
//        return PAppManager.shared.dateFormater.string(from: self)
//    }
    
    func freeFormat(_ format: String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        return fmt.string(from: self)
    }
    
//    func fromString(dateString: String, format: String? = "yyyy-MM-dd HH:mm:ss") -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        return dateFormatter.date(from: dateString)
//    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return self.calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return self.calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return self.calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return self.calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the day of week from another date
    func dayOfWeek(from date: Date) -> Int {
        return self.calendar.dateComponents([.weekday], from: date, to: self).weekday ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return self.calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return self.calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return self.calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if self.years(from: date) > 0 { return "\(self.years(from: date))y" }
        if self.months(from: date) > 0 { return "\(self.months(from: date))M" }
        if self.weeks(from: date) > 0 { return "\(self.weeks(from: date))w" }
        if self.days(from: date) > 0 { return "\(self.days(from: date))d" }
        if self.hours(from: date) > 0 { return "\(self.hours(from: date))h" }
        if self.minutes(from: date) > 0 { return "\(self.minutes(from: date))m" }
        if self.seconds(from: date) > 0 { return "\(self.seconds(from: date))s" }
        
        return ""
    }
}

extension TimeInterval {
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let time = NSInteger(interval)
        
        let ms = Int(self.truncatingRemainder(dividingBy: 1) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, ms)
    }
}

extension Date {
    var convertedDate: Date {
        return self
//
//        let dateFormatter = DateFormatter();
//        let formattedDate = dateFormatter.string(from: self);
//        dateFormatter.dateStyle = .full
//        dateFormatter.timeStyle = .full
//        dateFormatter.locale =  Locale(identifier: "en_US_POSIX");
//        let sourceDate = dateFormatter.date(from: formattedDate as String);
//
//        return sourceDate!;
    }
}
