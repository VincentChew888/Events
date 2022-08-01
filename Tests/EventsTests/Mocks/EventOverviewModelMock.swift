//
//  EventOverviewModelMock.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

@testable import Events

extension EventsOverview {
    static func mockData() -> [EventsOverviewDataModel] {
        [EventsOverviewDataModelMock(title: "Chad\'s Awesome Event",
                                     heroImageThumbnail: EventsFileContentDataModelMock(contentType: "image/jpeg",
                                                                                        fileSize: "296929",
                                                                                        fileName: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg",
                                                                                        isDir: false,
                                                                                        title: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp.jpg",
                                                                                        uid: "blt04a15b7eb95f2262",
                                                                                        url: "https://images.contentstack.io/_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg"),
                                     eventStart: "2022-06-09T04:00:00.000Z",
                                     eventEnd: "2022-06-10T03:16:06.000Z",
                                     location: "contentstack-blt1e13cb9",
                                     isSaved: false,
                                     eventId: "Cool Kids Row",
                                     registrationRequired: false,
                                     virtualEvent: false),
         EventsOverviewDataModelMock(title: "Chad\'s Awesome Event",
                                     heroImageThumbnail: EventsFileContentDataModelMock(contentType: "image/jpeg",
                                                                                        fileSize: "296929",
                                                                                        fileName: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg",
                                                                                        isDir: false,
                                                                                        title: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp.jpg",
                                                                                        uid: "blt04a15b7eb95f2262",
                                                                                        url: "https://images.contentstack.io/_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg"),
                                     eventStart: "2022-06-09T09:00:00.000Z",
                                     eventEnd: "2022-06-10T03:16:06.000Z",
                                     location: "Cool Kids Row",
                                     isSaved: false,
                                     eventId: "contentstack-blt1e13cb9",
                                     registrationRequired: true,
                                     virtualEvent: true),
         EventsOverviewDataModelMock(title: "Chad\'s Awesome Event Tomorrow",
                                     heroImageThumbnail: EventsFileContentDataModelMock(contentType: "image/jpeg",
                                                                                        fileSize: "296929",
                                                                                        fileName: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg",
                                                                                        isDir: false,
                                                                                        title: "[Placeholder_Image]_NEW_PROGRAM_-_7-day_skin_care_camp.jpg",
                                                                                        uid: "blt04a15b7eb95f2262",
                                                                                        url: "https://images.contentstack.io/_NEW_PROGRAM_-_7-day_skin_care_camp_2.jpg"),
                                     eventStart: "2022-06-10T04:00:00.000Z",
                                     eventEnd: "2022-06-10T03:16:06.000Z",
                                     location: "Cool Kids Row",
                                     isSaved: false,
                                     eventId: "contentstack-blt1e13cb9",
                                     registrationRequired: false,
                                     virtualEvent: false)]
    }
}

struct EventsOverviewDataModelMock: EventsOverviewDataModel {
    var title: String

    var heroImageThumbnail: EventsFileContentDataModel?

    var savedHeroImage: EventsFileContentDataModel?

    var eventStart: String?

    var eventEnd: String?

    var location: String

    var isSaved: Bool

    var eventId: String

    var registrationRequired: Bool

    var virtualEvent: Bool
}

struct EventsFileContentDataModelMock: EventsFileContentDataModel {
    var contentType: String

    var fileSize: String

    var fileName: String

    var isDir: Bool

    var title: String

    var uid: String

    var url: String
}
