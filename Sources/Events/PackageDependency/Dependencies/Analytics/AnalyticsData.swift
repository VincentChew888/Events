//
//  AnalyticsData.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import CommonInteractions
import Foundation

public struct AnalyticsData: AnalyticsEvent {
    public var name: String
    var eventId: String
    var eventTitle: String
    var registrationRequired: String
    var virtualEvent: String
    var mediaId: String?

    var shareType: String? {
        if name == EventsAnalytics.shareEvent.rawValue {
            return "event"
        } else if name == EventsAnalytics.shareMedia.rawValue {
            return "event media"
        }
        return nil
    }

    public func encode() -> Metadata {
        let convertedPayload = ["eventID": eventId,
                                "eventTitle": eventTitle,
                                "registrationRequired": registrationRequired,
                                "virtualEvent": virtualEvent,
                                "shareType": shareType,
                                "mediaID": mediaId]
            .compactMapValues { $0 }

        return convertedPayload.lowercaseValues()
    }
}

enum EventsAnalytics: String {
    case saveEvent = "Events: Tap: Save Event"
    case viewEventDetails = "Events: View: Event Details"
    case shareEvent = "Sharebar: Event"
    case shareMedia = "Sharebar: Event Media"
    case addToCalendar = "Events: Tap: Add to Calendar"
    case registerForEvent = "Events: Tap: Register"
    case getDirections = "Events: Tap: Get Directions"
    case viewEventMedia = "Events: Tap: Media"
}

enum AnalyticsConstant {
    static let trueString = "t"
    static let falseString = "f"
}
