//
//  SavedEventsModel.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

public enum SavedEvent {
    public enum Model {
        public struct Request {
            var isSavedEvents: Bool = false
        }

        public struct Response {
            var events: [EventsOverviewDataModel]
            var staticData: SavedEventsFields

            public init(events: [EventsOverviewDataModel],
                        staticData: SavedEventsFields)
            {
                self.events = events
                self.staticData = staticData
            }
        }

        public struct ViewModel {
            var events: [SavedEventsData]
            var staticData: SavedEventsFields
        }
    }
}

struct SavedEventsData: Identifiable {
    var id = UUID().uuidString
    var eventId: String
    var title: String
    var description: String
    var imageUrl: String
    var isSaved: Bool
    var registrationRequired: Bool
    var virtualEvent: Bool
}

extension SavedEvent {
    static func constructViewModel(using eventsList: [EventsOverviewDataModel]) -> [SavedEventsData] {
        var events: [SavedEventsData] = []
        for event in eventsList.sorted(by: { $0.eventStart?.isoDate() ?? Date() < $1.eventStart?.isoDate() ?? Date() }) {
            let savedEvent = SavedEventsData(eventId: event.eventId,
                                             title: event.title,
                                             description: getEventInfo(startTime: event.eventStart, location: event.location),
                                             imageUrl: event.savedHeroImage?.url ?? "",
                                             isSaved: event.isSaved,
                                             registrationRequired: event.registrationRequired,
                                             virtualEvent: event.virtualEvent)
            events.append(savedEvent)
        }
        return events
    }

    static func getEventInfo(startTime: String?, location: String) -> String {
        guard let startTime = startTime else {
            return "\(location)"
        }
        return "\(getStartTime(startTime: startTime)) · \(location)"
    }

    static func getStartTime(startTime: String) -> String {
        let date = startTime.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.monthDateAndHours)
        let time = startTime.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.hourAndMin)
        return "\(date) · \(time)"
    }
}
