//
//  EventDetailDataModelMock.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Events
import Foundation

extension EventDetail {
    static func virtualMediaEvent() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithoutMedia and virtual true with registrationRequired false",
                                 eventDescription: "test EventsWithoutMedia and virtual true with registrationRequired false",
                                 heroImage: EventDetail.mockImage(),
                                 registrationRequired: false,
                                 publicDetailsLink: "testLink",
                                 registrationLink: "testLink",
                                 eventStart: "2022-06-10T04:00:00.000Z",
                                 eventEnd: "2022-06-10T03:16:06.000Z",
                                 virtualEvent: true,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: true,
                                 address: "",
                                 eventShareText: "this is shareText",
                                 media: EventDetail.mockMedia(),
                                 eventAudience: "")
    }

    static func mockEvent() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "testLink",
                                 registrationLink: "testLink",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: false,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "")
    }

    static func mockImage() -> EventsFileContentDataModel {
        EventsFileContentDataModelMock(contentType: "image/jpeg",
                                       fileSize: "296929",
                                       fileName: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg",
                                       isDir: false,
                                       title: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp.jpg",
                                       uid: "blt04a15b7eb95f2262",
                                       url: "https://images.contentstack.io/_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg")
    }

    static func mockVedio() -> EventsFileContentDataModel {
        EventsFileContentDataModelMock(contentType: "video/jpeg",
                                       fileSize: "296929",
                                       fileName: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg",
                                       isDir: false,
                                       title: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp.jpg",
                                       uid: "blt04a15b7eb95f2262",
                                       url: "https://images.contentstack.io/_NEW_PROGRAM_-_7-day_skin_care_camp_2.mov")
    }

    static func mockMedia() -> [EventsMediaContentDataModel] {
        [EventsMediaContentDataModelMock(contentTypeUID: "contentTypeUID",
                                         contentURL: "http:testUrl",
                                         description: "test media description",
                                         locale: "en-us",
                                         thumbnailImage: mockImage(),
                                         contentFile: mockImage(),
                                         thumbnailURL: "test ImageUrl",
                                         title: "Media for image",
                                         uid: "testUID", videoShareLink: ""),
         EventsMediaContentDataModelMock(contentTypeUID: "contentTypeUID",
                                         contentURL: "http:testUrl",
                                         description: "test media description",
                                         locale: "en-us",
                                         thumbnailImage: mockVedio(),
                                         contentFile: mockVedio(),
                                         thumbnailURL: "test thumnail",
                                         title: "Media for image",
                                         uid: "testUID", videoShareLink: "videoShareLink"),
         EventsMediaContentDataModelMock(contentTypeUID: "contentTypeUID",
                                         contentURL: "http:testUrl",
                                         description: "test media description",
                                         locale: "en-us",
                                         thumbnailImage: nil,
                                         contentFile: nil,
                                         thumbnailURL: "test thumnail",
                                         title: "Media for image",
                                         uid: "testUID", videoShareLink: "videoShareLink")]
    }

    static func virtualEventMock() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "testLink",
                                 registrationLink: "testLink",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: true,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "Florida, USA",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "Public Event")
    }

    static func nonVirtualEventMock() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "testLink",
                                 registrationLink: "testLink",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: false,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "Florida, USA",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "Public Event")
    }

    static func registrationLinkEventMock() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "",
                                 registrationLink: "registration link",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: false,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "Florida, USA",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "Public Event")
    }

    static func publicDetailsLinkEventMock() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "public details link",
                                 registrationLink: "",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: false,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "Florida, USA",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "Public Event")
    }

    static func registrationAndPublicDetailsLinkEventMock() -> EventDetailDataModel {
        EventDetailDataModelMock(eventId: "",
                                 title: "test EventsWithMedia without virtual with registrationRequired true ",
                                 eventDescription: "test EventsWithMedia without virtual with registrationRequired true ",
                                 heroImage: nil,
                                 registrationRequired: true,
                                 publicDetailsLink: "public details link",
                                 registrationLink: "registration link",
                                 eventStart: nil,
                                 eventEnd: nil,
                                 virtualEvent: false,
                                 location: "Cool Kids Row",
                                 isAddedToCalendar: true,
                                 isSaved: false,
                                 address: "Florida, USA",
                                 eventShareText: "this is shareText",
                                 media: [],
                                 eventAudience: "Public Event")
    }
}

struct EventDetailDataModelMock: EventDetailDataModel {
    var eventId: String

    var title: String

    var eventDescription: String

    var heroImage: EventsFileContentDataModel?

    var registrationRequired: Bool
    var publicDetailsLink: String

    var registrationLink: String

    var eventStart: String?

    var eventEnd: String?

    var virtualEvent: Bool

    var location: String

    var isAddedToCalendar: Bool

    var isSaved: Bool

    var address: String

    var eventShareText: String

    var media: [EventsMediaContentDataModel]

    var eventAudience: String

    var savedHeroImage: EventsFileContentDataModel?

    var heroImageThumbnail: EventsFileContentDataModel?
}

struct EventsMediaContentDataModelMock: EventsMediaContentDataModel {
    var contentTypeUID: String

    var contentURL: String

    var description: String

    var locale: String

    var thumbnailImage: EventsFileContentDataModel?

    var contentFile: EventsFileContentDataModel?

    var thumbnailURL: String

    var title: String

    var uid: String

    var videoShareLink: String
}
