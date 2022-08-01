//
//  DateFormatter+Extension.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static func toDate(using text: String) -> Date? {
        return iso8601Full.date(from: text)
    }

    static func toString(using date: Date) -> String {
        return iso8601Full.string(from: date)
    }
}
