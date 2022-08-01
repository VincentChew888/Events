//
//  EventsOverviewDataModel.swift
//  Events
//
//  Copyright © 2022 Amway. All rights reserved.
//

///  Used in EventsDataProviderLogic to get dynamic api  data from app to this package.
///  Actual implementation of this protocol shall reside in application side
public protocol EventsOverviewDataModel {
    var title: String { get }
    var heroImageThumbnail: EventsFileContentDataModel? { get }
    var savedHeroImage: EventsFileContentDataModel? { get }
    var eventStart: String? { get }
    var eventEnd: String? { get }
    var location: String { get }
    var isSaved: Bool { get }
    var eventId: String { get }
    var registrationRequired: Bool { get }
    var virtualEvent: Bool { get }
}

///  Used by EventsOverviewDataModel to get file related data.
///  Actual implementation of this protocol shall reside in application side
public protocol EventsFileContentDataModel {
    var contentType: String { get }
    var fileSize: String { get }
    var fileName: String { get }
    var isDir: Bool { get }
    var title: String { get }
    var uid: String { get }
    var url: String { get }
}
