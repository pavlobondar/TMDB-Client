//
//  DateFormatterService.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

final class DateFormatterService {
    private static let formatter: DateFormatter = DateFormatter()
    
    static func getDayMonthYearFormat(_ date: Date) -> String {
        formatter.dateFormat = "d MMM, YYYY"
        return formatter.string(from: date)
    }
    
    static func getDate(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "Today " + formatter.string(from: date)
        } else {
            return getDayMonthYearFormat(date)
        }
    }
    
    static func getReleaseDateFrom(string: String?) -> Date? {
        guard let string = string else {
            return nil
        }
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}
