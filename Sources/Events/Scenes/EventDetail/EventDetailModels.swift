//
//  File.swift
//
//
//  Created by Amway on 15/06/22.
//

import Foundation

enum EventType: String {
    case aboEvent = "ABO event"
    case publicEvent = "Public event"
}

public enum EventDetail {
    public enum Model {
        public struct Request {
            public var eventId: String

            public init(eventId: String) {
                self.eventId = eventId
            }
        }

        public struct CalendarRequest {
            public var event: CalendarEventData
        }

        public struct CalendarResponse {
            public var event: CalendarEventData
        }

        struct Response {
            var eventdetails: EventDetailDataModel
            var staticData: EventDetailFields
        }

        struct ViewModel {
            var eventsHeaderViewData: EventDetailHeaderView.ViewData
            var eventShareData: ShareData
            var eventDetailSection: EventDetailSection
            var mediaSection: MediaSection
            var registerButtonData: RegisterSection
            var calendarEventData: CalendarEventData
            var staticData: EventDetailFields
        }

        struct AnalyticsInfo {
            var eventId: String
            var eventTitle: String
            var registrationRequired: Bool
            var virtualEvent: Bool
        }
    }

    /// Business Logic for conversion of Start date to desired format eg.  Saturday, 2022 July 16
    static func dayYearMonthAndDate(eventStart: String?,
                                    staticData: EventDetailFields) -> String
    {
        if let isToday = eventStart?.isoDate()?.isToday, isToday {
            return staticData.eventCardDateTitle.today
        }
        if let isTomorrow = eventStart?.isoDate()?.isTomorrow, isTomorrow {
            return staticData.eventCardDateTitle.tomorrow
        }
        return eventStart?.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.dayYearMonthAndDate) ?? ""
    }
}

// MARK: - Sections for ViewModel

extension EventDetail {
    struct EventDetailSection {
        var eventsDetailSectionTitle: String
        var eventDetailSections: [EventDetailCell.ViewData]
    }

    struct MediaSection {
        var mediaSectionTitle: String
        var mediaItems: [EventsMediaCell.MediaData]
    }

    struct RegisterSection {
        var registrationLink: String
        var registerationButtonTitle: String
    }

    struct AlertData {
        var addToCalendarTitle: String
        var addToCalendarDesc: String
        var addEventButton: String
        var cancelButton: String
        var goToSettingsTitle: String
        var goToSettingsDescription: String
        var goToSettingsButton: String
    }

    public struct ShareData {
        public var isAboEvent: Bool
        public var title: String
        public var description: String
        public var linkInfo: String
        public var heroImageUrl: String
        public var startDateTime: Date
        public var endDateTime: Date
        public var locationOrAddress: String
        public var shareText: String

        public init(aboEvent: Bool,
                    title: String,
                    description: String,
                    linkInfo: String,
                    heroImageUrl: String,
                    startDateTime: Date,
                    endDateTime: Date,
                    locationOrAddress: String,
                    shareText: String)
        {
            isAboEvent = aboEvent
            self.title = title
            self.description = description
            self.linkInfo = linkInfo
            self.heroImageUrl = heroImageUrl
            self.startDateTime = startDateTime
            self.endDateTime = endDateTime
            self.locationOrAddress = locationOrAddress
            self.shareText = shareText
        }

        public init(eventDetail: EventDetailDataModel, eventFields: EventDetailFields) {
            isAboEvent = eventDetail.eventAudience == EventType.aboEvent.rawValue

            title = eventDetail.title.replacingOccurrences(of: "\n", with: ",")

            var eventLink = ""
            if !eventDetail.registrationLink.isEmpty {
                eventLink = "\(eventFields.registrationLinkShareText)\(eventDetail.registrationLink)"
            } else if !eventDetail.publicDetailsLink.isEmpty {
                eventLink = "\(eventFields.publicDetailsLinkShareText)\(eventDetail.publicDetailsLink)"
            }

            let linkText = eventLink.isEmpty ? "" : "\\n\\n\(eventLink)"
            let registrationStatusText = eventDetail.registrationRequired ? eventFields.yesRegistrationRequired : eventFields.noRegistrationRequired
            let registrationText = registrationStatusText.isEmpty ? "" : "\\n\\n\(registrationStatusText)"

            description = "\(eventDetail.eventDescription)\(registrationText)\(linkText)"

            linkInfo = eventLink

            heroImageUrl = eventDetail.heroImage?.url ?? ""
            startDateTime = eventDetail.eventStart?.isoDate() ?? Date()
            endDateTime = eventDetail.eventEnd?.isoDate() ?? Date()

            let locationText = eventDetail.virtualEvent ? eventDetail.location : eventDetail.address
            locationOrAddress = locationText.replacingOccurrences(of: "\n", with: ",")

            shareText = eventDetail.eventShareText
        }
    }

    struct MediaAlertInfo {
        var showAlert = false
        var mediaType: MediaType = .image
    }
}
