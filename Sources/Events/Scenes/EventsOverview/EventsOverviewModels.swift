//
//  EventsOverviewModels.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

public struct EventsFetchRequest {
    public var isSavedEvents: Bool = false

    public init(isSavedEvents: Bool = false) {
        self.isSavedEvents = isSavedEvents
    }
}

enum EventsOverview {
    // MARK: Use cases

    enum Model {
        struct Request {
            var isSavedEvents: Bool = false
        }

        struct Response {
            var events: [EventsOverviewDataModel]
            var model: EventsOverViewFields
        }

        public struct ViewModel {
            var sections: [EventsSection]
            var segmentListData: SegmentListViewBuilder.ViewData
        }

        struct ToastStaticData {
            let saveEventErrorTitle: String
            let saveEventErrorDescription: String
        }
    }
}

public struct EventsData: Identifiable {
    public var eventId: String
    public var eventStartDate: String
    public var eventMonth: Int
    public var title: String
    public var description: String
    public var imageUrl: String
    public var isSaved: Bool
    public var registrationRequired: Bool
    public var virtualEvent: Bool

    public var id: String {
        eventId
    }

    public init(eventId: String,
                eventStartDate: String,
                eventMonth: Int,
                title: String,
                description: String,
                imageUrl: String,
                isSaved: Bool,
                registrationRequired: Bool,
                virtualEvent: Bool)
    {
        self.eventId = eventId
        self.eventStartDate = eventStartDate
        self.eventMonth = eventMonth
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.isSaved = isSaved
        self.registrationRequired = registrationRequired
        self.virtualEvent = virtualEvent
    }
}

public struct EventsSection: Identifiable, Comparable {
    public var id = UUID().uuidString
    public var month: Int
    public var date: Date
    public var events: [EventsData]
    public var title: String

    public init(month: Int,
                date: Date,
                events: [EventsData],
                title: String)
    {
        self.month = month
        self.date = date
        self.events = events
        self.title = title
    }

    public static func < (lhs: EventsSection, rhs: EventsSection) -> Bool {
        lhs.date.timeIntervalSince1970 < rhs.date.timeIntervalSince1970
    }

    public static func == (lhs: EventsSection, rhs: EventsSection) -> Bool {
        lhs.id == rhs.id
    }
}

public struct SaveEventRequest {
    public var eventId: String
    public var isSaved: Bool
    public var filterOnlySavedEvents: Bool
    public var individualEvent: Bool

    public init(eventId: String,
                isSaved: Bool,
                filterOnlySavedEvents: Bool = false,
                individualEvent: Bool = false)
    {
        self.eventId = eventId
        self.isSaved = isSaved
        self.filterOnlySavedEvents = filterOnlySavedEvents
        self.individualEvent = individualEvent
    }
}

extension EventsOverview {
    static func sections(using eventsList: [EventsOverviewDataModel], staticData: EventsOverViewFields) -> [EventsSection] {
        let currentMonth = Date().getMonth()
        let currentYear = Date().getYear()
        var defaultMonthsData: [Int: [EventsData]] = [:]

        // Populate the dictionary with next 11 values of currentMonth
        for index in currentMonth ... currentMonth + ((Constants.numberOfYears * Constants.lastMonthIndex) - 1) {
            defaultMonthsData[index] = []
        }
        // Map api data
        var eventSections: [EventsSection] = []

        for event in eventsList.sorted(by: { $0.eventStart?.isoDate() ?? Date() < $1.eventStart?.isoDate() ?? Date() }) {
            var eventMonth = event.eventStart?.isoDate()?.getMonth() ?? currentMonth
            let eventYear = event.eventStart?.isoDate()?.getYear() ?? currentYear
            if eventYear > currentYear {
                let differenceInYear = eventYear - currentYear
                eventMonth += (differenceInYear * Constants.lastMonthIndex)
            }

            let eventData = EventsData(eventId: event.eventId,
                                       eventStartDate: event.eventStart ?? "",
                                       eventMonth: eventMonth,
                                       title: event.title,
                                       description: getEventDescription(startTime: event.eventStart, location: event.location),
                                       imageUrl: event.heroImageThumbnail?.url ?? "",
                                       isSaved: event.isSaved,
                                       registrationRequired: event.registrationRequired,
                                       virtualEvent: event.virtualEvent)
            if let index = eventSections.firstIndex(where: { $0.date == eventData.eventStartDate.isoDate()?.startOfTheDay() ?? Date() }) {
                eventSections[index].events.append(eventData)
            } else {
                eventSections.append(EventsSection(month: eventMonth,
                                                   date: eventData.eventStartDate.isoDate()?.startOfTheDay() ?? Date(),
                                                   events: [eventData],
                                                   title: sectionKey(eventStart: eventData.eventStartDate, staticData: staticData)))
            }

            defaultMonthsData.removeValue(forKey: eventMonth)
        }

        for key in defaultMonthsData.keys {
            eventSections.append(EventsSection(month: key,
                                               date: Date().startOfYear()?.getMonth(byAdding: key - 1) ?? Date(),
                                               events: [],
                                               title: sectionKey(month: key, eventStart: "", staticData: staticData)))
        }
        eventSections.sort(by: { $0.date < $1.date })
        return eventSections
    }

    /// Constructs Valid section heeader text to display in view
    /// If eventStart is today or tomorrow, returns valida data fetched from CS
    /// If Future date, returns date "EEEE, MMMM d" format
    /// If no data in month, returns "MonthName - No events"
    static func sectionKey(month: Int? = nil, eventStart: String, staticData: EventsOverViewFields) -> String {
        if let month = month {
            let year = month / Constants.lastMonthIndex
            var value = 1
            // To get valid month name from monthSymbol using input 'month'.
            if month % Constants.lastMonthIndex == 0 {
                value = (year - 1) * Constants.lastMonthIndex + 1
            } else {
                value = (year * Constants.lastMonthIndex) + 1
            }
            let monthName = Date.dateFormatter.monthSymbols[month - value]
            return staticData.emptyMonthDescription.replacingOccurrences(of: "{{Month}}", with: "\(monthName)")
        }
        if eventStart.isEmpty {
            return staticData.emptyMonthDescription
        }
        if let isToday = eventStart.isoDate()?.isToday, isToday {
            return staticData.eventCardDateTitle.today
        }
        if let isTomorrow = eventStart.isoDate()?.isTomorrow, isTomorrow {
            return staticData.eventCardDateTitle.tomorrow
        }
        return eventStart.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.dayMonthAndDate)
    }

    static func getEventDescription(startTime: String?, location: String) -> String {
        guard let startTime = startTime else {
            return "\(location)"
        }
        return "\(getStartTime(startTime: startTime)) • \(location)"
    }

    static func getStartTime(startTime: String) -> String {
        return startTime.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.hourAndMin)
    }

    static func getEndTime(endTime: String) -> String {
        return endTime.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.hourAndMin)
    }

    static func getDuration(startTime: String, endTime: String) -> String {
        guard let startTimeDate = startTime.isoDate(), let endTimeDate = endTime.isoDate() else {
            return ""
        }
        if startTimeDate > endTimeDate {
            return ""
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: startTimeDate, to: endTimeDate) ?? ""
    }
}

extension EventsOverview {
    enum Constants {
        static let lastMonthIndex: Int = 12
        static let numberOfYears: Int = 1
    }
}
