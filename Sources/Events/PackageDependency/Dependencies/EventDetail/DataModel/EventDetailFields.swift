//
//  File.swift
//
//
//  Created by Amway on 16/06/22.
//

import Foundation

public protocol EventDetailFields {
    var screenTitle: String { get }
    var expandDescriptionCtaTitle: String { get }
    var collapseDescriptionCtaTitle: String { get }
    var saveEventErrorTitle: String { get }
    var saveEventErrorDescription: String { get }
    var eventAudiencePublic: String { get }
    var eventDetailsSectionHeader: String { get }
    var eventAudienceAboOnly: String { get }
    var registrationLinkShareText: String { get }
    var publicDetailsLinkShareText: String { get }
    var addToiphoneCalendarRequestTitle: String { get }
    var dateAddToCalendarCta: String { get }
    var addToCalendarRequestDescription: String { get }
    var addToCalendarCancelCta: String { get }
    var addToiphoneCalendarSuccessTitle: String { get }
    var addToCalendarSuccessDescription: String { get }
    var addToCalendarErrorDescription: String { get }
    var calendarPermissionsNeededTitle: String { get }
    var noRegistrationRequired: String { get }
    var calendarPermissionsSettingsCta: String { get }
    var calendarPermissionsCancelCta: String { get }
    var locationMapAddress: String { get }
    var locationMapCta: String { get }
    var mediaSectionHeader: String { get }
    var calendarPermissionsNeededDescription: String { get }
    var registerUrl: String { get }
    var addToCalendarErrorTitle: String { get }
    var addToCalendarAddCta: String { get }
    var contentViewerExpandDescriptionCtaTitle: String { get }
    var registerButtonCta: String { get }
    var contentViewerCollapseDescriptionCtaTitle: String { get }
    var yesRegistrationRequired: String { get }
    var shareEventErrorTitle: String { get }
    var shareEventErrorDescription: String { get }
    var eventCardDateTitle: EventCardDateTitleFields { get }
    var mediaShareCTATitle: String { get }
}

public protocol MediaValidationErrorFields {
    var imageErrorTitle: String { get }
    var imageErrorMessage: String { get }
    var videoErrorTitle: String { get }
    var videoErrorMessage: String { get }
    var pdfErrorTitle: String { get }
    var pdfErrorMessage: String { get }
    var primaryActionText: String { get }
}
