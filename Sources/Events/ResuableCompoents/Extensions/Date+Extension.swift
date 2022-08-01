//
//  Date+Extension.swift
//  Calendar
//
//

import Foundation
import UIKit

struct DateFormat {
    static let monthString = "LLLL"
    static let monthStringShort = "LL"
    static let yearString = "yyyy"
    static let yearAndMonth = "yyyyMM"
    static let longFormat = "yyyy MMM dd, hh:mm a"
    static let monthAndYear = "MMMM yyyy"
    static let monthDateAndYear = "MMM dd, yyyy"
    static let date = "dd"
    static let monthShort = "MMM"
    static let monthAndDay = "M/d"
    static let yearMonthDay = "yyyy MMM dd"
    static let yearMonthDayWithHyphens = "yyyy-MM-dd"
    static let dayMonthAndDate = "EEEE, MMMM d"
    static let yearSpaceShorthandMonth = "yyyy MMM"
    static let hourAndMin = "hh:mm"
    static let monthDateAndHours = "MMMM dd"
    static let dayYearMonthAndDate = "EEEE, yyyy MMMM d"
}

enum DateConstants {
    static let daysInAWeek = 7
}

extension Date {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()

    private static let gmtTimeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current

    static let dateFormatterNonLocalized: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Date.gmtTimeZone
        return dateFormatter
    }()

    static let dateFormatterLocalized: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()

    func dateStringWithISOFormatAndLocaleCheck(using format: String = DateFormat.longFormat) -> String {
        let isoDateString = DateFormatter.toString(using: self)
        guard let isoDate = DateFormatter.toDate(using: isoDateString) else {
            return ""
        }
        if Locale.mergedLocale() == Locale.Constants.zh_tw.rawValue {
            Date.dateFormatterLocalized.setLocalizedDateFormatFromTemplate(format)
            return Date.dateFormatterLocalized.string(from: isoDate)
        } else {
            Date.dateFormatter.dateFormat = format
            return Date.dateFormatter.string(from: isoDate)
        }
    }

    /// Converts date to loclalised date according to time zone of the device.
    /// - UseCase: -  November 1  2021, 18:30 pm UTC time after localization  should get converted to November 2 2021 12:00 am  according to indian time zone [+5:30 Hours from GMT]"
    /// - Descrption: - Internally uses ISODateFormatter to perform localization
    /// - Parameter: - pass the format in which date is required - default is long format: "yyyy MMM dd, hh:mm a"
    /// - ReturnValue: - string
    func localizedDateStringWithISOFormat(using format: String = DateFormat.longFormat) -> String {
        let isoDateString = DateFormatter.toString(using: self)
        guard let isoDate = DateFormatter.toDate(using: isoDateString) else {
            return ""
        }
        Date.dateFormatter.dateFormat = format
        Date.dateFormatter.locale = Locale.preferredLocale()
        return Date.dateFormatter.string(from: isoDate)
    }

    func defaultLocalizedDateStringWithISOFormat(using format: String = DateFormat.longFormat) -> String {
        let isoDateString = DateFormatter.toString(using: self)
        guard let isoDate = DateFormatter.toDate(using: isoDateString) else {
            return ""
        }
        Date.dateFormatterLocalized.setLocalizedDateFormatFromTemplate(format)
        return Date.dateFormatterLocalized.string(from: isoDate)
    }

    func isoDate() -> Date? {
        let isoDateString = DateFormatter.toString(using: self)
        guard let isoDate = DateFormatter.toDate(using: isoDateString) else {
            return nil
        }
        return isoDate
    }

    func localizedDateStringWithoutISOFormat(using format: String = DateFormat.longFormat) -> String {
        Date.dateFormatterNonLocalized.locale = Locale.preferredLocale()
        Date.dateFormatterNonLocalized.dateFormat = format
        return Date.dateFormatterNonLocalized.string(from: self)
    }

    func defaultLocalizedDateStringWithoutISOFormat(using format: String = DateFormat.longFormat) -> String {
        Date.dateFormatterLocalized.setLocalizedDateFormatFromTemplate(format)
        return Date.dateFormatterLocalized.string(from: self)
    }

    /// Gives exact date to coming from server without consideration of timezone.
    func nonLocalizedDate() -> Date? {
        let dateString = Date.dateFormatterNonLocalized.string(from: self)
        return Date.dateFormatterNonLocalized.date(from: dateString)
    }

    func years(from date: Date) -> Int {
        guard let isoDate = isoDate() else {
            return 0
        }
        return Calendar.current.dateComponents([.year], from: date, to: isoDate).year ?? 0
    }

    /// startOfTheDay
    /// - parameters:
    /// - date: date
    /// - Returns: Start of the day
    ///
    func startOfTheDay() -> Date? {
        guard let isoDate = isoDate() else {
            return nil
        }
        return Calendar.current.startOfDay(for: isoDate)
    }

    /// getMonth
    /// - parameters:
    /// - byAdding : value to date. ex: 1 for next month, -1 for previous month
    /// - Returns: date plus one month
    func getMonth(byAdding value: Int) -> Date? {
        guard let isoDate = isoDate() else {
            return nil
        }
        return Calendar.current.date(byAdding: .month, value: value, to: isoDate)
    }

    /// getPreviousMonths
    /// - parameters:
    /// - numberOfMonths : number of month
    /// - includeCurrentMonth: Bool to check if including current month or not
    /// - Returns: array of dates in ascending order.
    func getPreviousMonths(numberOfMonths: Int, includeCurrentMonth: Bool = true) -> [Date] {
        var dateList: [Date?] = []

        for index in stride(from: includeCurrentMonth ? numberOfMonths - 1 : numberOfMonths,
                            to: 0, by: -1)
        {
            dateList.append(getMonth(byAdding: -index))
        }
        if includeCurrentMonth, let isoDate = isoDate() {
            dateList.append(isoDate)
        }
        return dateList.compactMap { $0 }
    }

    var isToday: Bool? {
        guard let isoDate = isoDate() else {
            return nil
        }
        return Calendar.current.isDateInToday(isoDate)
    }

    var isTomorrow: Bool? {
        guard let isoDate = isoDate() else {
            return nil
        }
        return Calendar.current.isDateInTomorrow(isoDate)
    }

    /// monthString
    /// - parameters:
    /// - date: date
    /// - Returns: month string
    func monthString() -> String {
        localizedDateStringWithISOFormat(using: DateFormat.monthString)
    }

    /// yearString
    /// - parameters:
    /// - date: date
    /// - Returns: year string
    func yearString() -> String {
        localizedDateStringWithISOFormat(using: DateFormat.yearString)
    }

    /// monthAndDayString
    /// - parameters:
    /// - date: date
    /// - Returns: month and day string. Eg:- "5/4", "7/28"
    func monthAndDayString() -> String {
        localizedDateStringWithoutISOFormat(using: DateFormat.monthAndDay)
    }

    /// daysInMonth
    /// - parameters:
    /// - date: date
    /// - Returns: number of days
    func daysInMonth() -> Int {
        guard let isoDate = isoDate() else {
            return 0
        }
        return Calendar.current.range(of: .day, in: .month, for: isoDate)?.count ?? 0
    }

    /// startOfMonth
    /// - Returns: start of month
    func startOfMonth() -> Date? {
        guard let isoDate = isoDate() else {
            return nil
        }
        let components = Calendar.current.dateComponents([.year, .month], from: isoDate)
        return Calendar.current.date(from: components)
    }

    /// startOfYear
    /// - Returns: start of Year
    func startOfYear() -> Date? {
        guard let isoDate = isoDate() else {
            return nil
        }
        let components = Calendar.current.dateComponents([.year], from: isoDate)
        return Calendar.current.date(from: components)
    }

    /// weekDay
    /// - parameters:
    /// - date: date
    /// - Returns: weekday number
    func weekDay() -> Int {
        guard let isoDate = isoDate() else {
            return 0
        }
        let component = Calendar.current.dateComponents([.weekday], from: isoDate)
        guard let weekDay = component.weekday else {
            return 1
        }
        return weekDay
    }

    /// getDaysInMonth
    /// - parameters:
    /// - byAdding: value to date.
    /// - Returns: number of days in a month
    func getDaysInMonth(byAdding value: Int) -> Int {
        guard let isoDate = isoDate(),
              let previousMonthDate = Calendar.current.date(byAdding: .month, value: value, to: isoDate)
        else {
            return 0
        }
        guard let range = Calendar.current.range(of: .day, in: .month, for: previousMonthDate) else {
            return 0
        }
        return range.count
    }

    /// sundayForDate
    /// - parameters:
    /// - date: date
    /// - Returns: sunday for this date
    func sundayForDate() -> Date? {
        guard var current = isoDate(),
              let oneWeekAgo = addDays(days: -DateConstants.daysInAWeek)
        else {
            return nil
        }

        while current > oneWeekAgo {
            let currentWeekDay = Calendar.current.dateComponents([.weekday], from: current).weekday
            if currentWeekDay == 1 {
                return current
            }
            guard let previousDay = current.addDays(days: -1) else {
                return nil
            }
            current = previousDay
        }
        return current
    }

    /// addDays
    /// - parameters:
    /// - days: number of days to add
    /// - Returns: date with added number of days
    func addDays(days: Int) -> Date? {
        guard let isoDate = isoDate() else {
            return nil
        }
        return Calendar.current.date(byAdding: .day, value: days, to: isoDate)
    }

    /// Returns day number of the date.
    /// - parameters:
    /// - date: date
    /// - Returns: day
    func day() -> Int {
        guard let isoDate = isoDate() else {
            return 0
        }
        let components = Calendar.current.dateComponents([.day], from: isoDate)
        guard let day = components.day else {
            return 0
        }
        return day
    }

    /// Returns month and date of the date concatenated as below example
    /// - Feb 27
    func getMonthAndDay() -> String {
        let day = localizedDateStringWithoutISOFormat(using: DateFormat.date)
        let month = localizedDateStringWithoutISOFormat(using: DateFormat.monthShort)
        return "\(month) \(day)"
    }

    /// Returns year and month of the date concatenated as below example
    /// - 202109
    func getMonthAndYear() -> Int {
        guard let monthAndYear = Int(localizedDateStringWithISOFormat(using: DateFormat.yearAndMonth)) else {
            return 0
        }
        return monthAndYear
    }

    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        guard let isoDate = isoDate(),
              let inputDate = date.isoDate()
        else {
            return 0
        }
        let components = Calendar.current.dateComponents([.day],
                                                         from: inputDate,
                                                         to: isoDate)
        guard let day = components.day else {
            return 0
        }
        return day
    }

    func getMonth() -> Int {
        Calendar.current.component(.month, from: self)
    }

    func getYear() -> Int {
        Calendar.current.component(.year, from: self)
    }
}
