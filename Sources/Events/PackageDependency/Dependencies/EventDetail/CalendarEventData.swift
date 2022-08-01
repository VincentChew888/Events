//
//  File.swift
//
//
//  Created by Priyanka on 21/06/22.
//

import Foundation

public struct CalendarEventData {
    public var eventId: String = UUID().uuidString
    public var startDate: Date = Date()
    public var endDate: Date = Date()
    public var title: String = ""
    public var isAllDay: Bool = false
    public var location: String = ""
    public var description: String = ""
}
