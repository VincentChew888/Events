//
//  EventDetailFeildsMock.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Events
import Foundation

struct EventDetailFeildsMock: EventDetailFields {
    init(screenTitle: String,
         expandDescriptionCtaTitle: String,
         collapseDescriptionCtaTitle: String,
         saveEventErrorTitle: String,
         saveEventErrorDescription: String,
         eventAudiencePublic: String,
         eventDetailsSectionHeader: String,
         eventAudienceAboOnly: String,
         registrationLinkShareText: String,
         publicDetailsLinkShareText: String,
         addToiphoneCalendarRequestTitle: String,
         dateAddToCalendarCta: String,
         addToCalendarRequestDescription: String,
         addToCalendarCancelCta: String,
         addToiphoneCalendarSuccessTitle: String,
         addToCalendarSuccessDescription: String,
         addToCalendarErrorDescription: String,
         calendarPermissionsNeededTitle: String,
         noRegistrationRequired: String,
         calendarPermissionsSettingsCta: String,
         calendarPermissionsCancelCta: String,
         locationMapAddress: String,
         locationMapCta: String,
         mediaSectionHeader: String,
         calendarPermissionsNeededDescription: String,
         registerUrl: String,
         addToCalendarAddCta: String,
         addToCalendarErrorTitle: String,
         contentViewerExpandDescriptionCtaTitle: String,
         registerButtonCta: String,
         contentViewerCollapseDescriptionCtaTitle: String,
         yesRegistrationRequired: String,
         shareEventErrorTitle: String,
         shareEventErrorDescription: String,
         eventCardDateTitle: EventCardDateTitleFields,
         mediaShareCTATitle: String)
    {
        self.screenTitle = screenTitle
        self.expandDescriptionCtaTitle = expandDescriptionCtaTitle
        self.collapseDescriptionCtaTitle = collapseDescriptionCtaTitle
        self.saveEventErrorTitle = saveEventErrorTitle
        self.saveEventErrorDescription = saveEventErrorDescription
        self.eventAudiencePublic = eventAudiencePublic
        self.eventDetailsSectionHeader = eventDetailsSectionHeader
        self.eventAudienceAboOnly = eventAudienceAboOnly
        self.registrationLinkShareText = registrationLinkShareText
        self.publicDetailsLinkShareText = publicDetailsLinkShareText
        self.addToiphoneCalendarRequestTitle = addToiphoneCalendarRequestTitle
        self.dateAddToCalendarCta = dateAddToCalendarCta
        self.addToCalendarRequestDescription = addToCalendarRequestDescription
        self.addToCalendarCancelCta = addToCalendarCancelCta
        self.addToiphoneCalendarSuccessTitle = addToiphoneCalendarSuccessTitle
        self.addToCalendarSuccessDescription = addToCalendarSuccessDescription
        self.addToCalendarErrorDescription = addToCalendarErrorDescription
        self.calendarPermissionsNeededTitle = calendarPermissionsNeededTitle
        self.noRegistrationRequired = noRegistrationRequired
        self.calendarPermissionsSettingsCta = calendarPermissionsSettingsCta
        self.calendarPermissionsCancelCta = calendarPermissionsCancelCta
        self.locationMapAddress = locationMapAddress
        self.locationMapCta = locationMapCta
        self.mediaSectionHeader = mediaSectionHeader
        self.calendarPermissionsNeededDescription = calendarPermissionsNeededDescription
        self.registerUrl = registerUrl
        self.addToCalendarErrorTitle = addToCalendarErrorTitle
        self.contentViewerExpandDescriptionCtaTitle = contentViewerExpandDescriptionCtaTitle
        self.registerButtonCta = registerButtonCta
        self.contentViewerCollapseDescriptionCtaTitle = contentViewerCollapseDescriptionCtaTitle
        self.yesRegistrationRequired = yesRegistrationRequired
        self.shareEventErrorTitle = shareEventErrorTitle
        self.shareEventErrorDescription = shareEventErrorDescription
        self.addToCalendarAddCta = addToCalendarAddCta
        self.eventCardDateTitle = eventCardDateTitle
        self.mediaShareCTATitle = mediaShareCTATitle
    }

    var screenTitle: String

    var expandDescriptionCtaTitle: String

    var collapseDescriptionCtaTitle: String

    var saveEventErrorTitle: String

    var saveEventErrorDescription: String

    var eventAudiencePublic: String

    var eventDetailsSectionHeader: String

    var eventAudienceAboOnly: String

    var registrationLinkShareText: String
    var publicDetailsLinkShareText: String

    var addToiphoneCalendarRequestTitle: String

    var dateAddToCalendarCta: String

    var addToCalendarRequestDescription: String

    var addToCalendarCancelCta: String

    var addToiphoneCalendarSuccessTitle: String

    var addToCalendarSuccessDescription: String

    var addToCalendarErrorDescription: String

    var calendarPermissionsNeededTitle: String

    var noRegistrationRequired: String

    var calendarPermissionsSettingsCta: String

    var calendarPermissionsCancelCta: String

    var locationMapAddress: String

    var locationMapCta: String

    var mediaSectionHeader: String

    var calendarPermissionsNeededDescription: String

    var registerUrl: String

    var addToCalendarErrorTitle: String

    var contentViewerExpandDescriptionCtaTitle: String

    var registerButtonCta: String

    var contentViewerCollapseDescriptionCtaTitle: String

    var yesRegistrationRequired: String

    var shareEventErrorTitle: String

    var shareEventErrorDescription: String

    var eventCardDateTitle: EventCardDateTitleFields

    var addToCalendarAddCta: String

    var mediaShareCTATitle: String

    static func mockData() -> EventDetailFeildsMock {
        EventDetailFeildsMock(screenTitle: "test EventDetailTitle",
                              expandDescriptionCtaTitle: "",
                              collapseDescriptionCtaTitle: "",
                              saveEventErrorTitle: "",
                              saveEventErrorDescription: "",
                              eventAudiencePublic: "",
                              eventDetailsSectionHeader: "",
                              eventAudienceAboOnly: "",
                              registrationLinkShareText: "",
                              publicDetailsLinkShareText: "",
                              addToiphoneCalendarRequestTitle: "",
                              dateAddToCalendarCta: "",
                              addToCalendarRequestDescription: "",
                              addToCalendarCancelCta: "",
                              addToiphoneCalendarSuccessTitle: "",
                              addToCalendarSuccessDescription: "",
                              addToCalendarErrorDescription: "",
                              calendarPermissionsNeededTitle: "",
                              noRegistrationRequired: "",
                              calendarPermissionsSettingsCta: "",
                              calendarPermissionsCancelCta: "",
                              locationMapAddress: "",
                              locationMapCta: "",
                              mediaSectionHeader: "", calendarPermissionsNeededDescription: "",
                              registerUrl: "",
                              addToCalendarAddCta: "",
                              addToCalendarErrorTitle: "",
                              contentViewerExpandDescriptionCtaTitle: "",
                              registerButtonCta: "",
                              contentViewerCollapseDescriptionCtaTitle: "",
                              yesRegistrationRequired: "",
                              shareEventErrorTitle: "",
                              shareEventErrorDescription: "",
                              eventCardDateTitle: EventCardDateTitleFieldsMock(tomorrow: "",
                                                                               today: ""),
                              mediaShareCTATitle: "")
    }
}

struct MediaValidationErrorFieldsMock: MediaValidationErrorFields {
    var imageErrorTitle: String
    var imageErrorMessage: String
    var videoErrorTitle: String
    var videoErrorMessage: String
    var pdfErrorTitle: String
    var pdfErrorMessage: String
    var primaryActionText: String

    static func mockData() -> MediaValidationErrorFields {
        MediaValidationErrorFieldsMock(imageErrorTitle: "imageErrorTitle",
                                       imageErrorMessage: "imageErrorMessage",
                                       videoErrorTitle: "videoErrorTitle",
                                       videoErrorMessage: "videoErrorMessage",
                                       pdfErrorTitle: "pdfErrorTitle",
                                       pdfErrorMessage: "pdfErrorMessage",
                                       primaryActionText: "primaryActionText")
    }
}
