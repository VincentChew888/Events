//
//  File.swift
//
//
//  Created by Amway on 16/06/22.
//

import Foundation

public protocol EventDetailDataModel: EventsOverviewDataModel {
    var eventDescription: String { get }
    var heroImage: EventsFileContentDataModel? { get }
    var publicDetailsLink: String { get }
    var registrationLink: String { get }
    var isAddedToCalendar: Bool { get }
    var address: String { get }
    var eventShareText: String { get }
    var media: [EventsMediaContentDataModel] { get }
    var eventAudience: String { get }
}

public protocol EventsMediaContentDataModel {
    var contentTypeUID: String { get }
    var contentURL: String { get }
    var description: String { get }
    var locale: String { get }
    var thumbnailImage: EventsFileContentDataModel? { get }
    var contentFile: EventsFileContentDataModel? { get }
    var thumbnailURL: String { get }
    var title: String { get }
    var uid: String { get }
    var videoShareLink: String { get }
}

public protocol EventMediaDataModel {
    var mediaType: MediaType { get }
    var mediaURL: String { get }
    var mediaTitle: String { get }
    var shareURL: String { get }
    var thumbnailURL: String { get }
    var shareTitle: String { get }
    var contentId: String { get }
}

public enum MediaType: String {
    case image
    case video
    case pdf
}
