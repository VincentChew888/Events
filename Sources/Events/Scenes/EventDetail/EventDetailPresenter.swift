//
//  File.swift
//
//
//  Created by Amway on 15/06/22.
//

import Combine
import Foundation

final class EventDetailPresenter: ObservableObject {
    private var interactor: EventDetailBusinessLogic
    private var router: EventDetailRouter?
    private var cancellables = Set<AnyCancellable>()
    private var analyticsInfo: EventDetail.Model.AnalyticsInfo?
    private(set) var appStateForegroundNotification = ApplicationWillEnterForegroundManager()

    private var eventId: String = ""

    init(interactor: EventDetailBusinessLogic) {
        self.interactor = interactor
    }

    // MARK: Injection

    func setRouter(_ router: EventDetailRouter) {
        self.router = router
    }

    enum State {
        case isLoading
        case failure(FailureType)
        case success(EventDetail.Model.ViewModel)
    }

    enum CalendarStatus {
        case isLoading
        case failure
        case success
    }

    enum CalendarAutorization {
        case isLoading
        case authorized
        case denied
    }

    enum FailureType {
        case connectivity
        case internet
    }

    @Published var state = State.isLoading
    @Published var calendarStatus = CalendarStatus.isLoading
    @Published var calendarAuthorization = CalendarAutorization.isLoading
    @Published var showCalendarToast = false
    @Published var showSaveEventFailureToast = false
    private(set) var calendarToastData: ToastView.ViewData?
    private(set) var saveEventFailureToastData: ToastView.ViewData?
}

extension EventDetailPresenter {
    func setEventId(_ eventId: String) {
        self.eventId = eventId
    }

    func fetchTitle() -> String {
        interactor.fetchEventDetailFields()?.screenTitle ?? ""
    }

    func fetchEventDetail(type: EventsDataFetchType, completionHandler: (() -> Void)? = nil) {
        let request = EventDetail.Model.Request(eventId: eventId)
        interactor.fetchEventDetail(request: request, type: type)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                completionHandler?()

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            self.state = .failure(.internet)
                        case CommonServiceError.duplicateApiCall.localizedDescription:
                            return
                        default:
                            self.state = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleEventDetailResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    func authorizationStatus() {
        interactor.getAuthorisationStatus { [weak self] calendarStatus in
            guard let self = self,
                  calendarStatus
            else {
                self?.calendarAuthorization = CalendarAutorization.denied
                return
            }
            self.calendarAuthorization = CalendarAutorization.authorized
        }
    }

    func saveEvent(event: CalendarEventData) {
        interactor.save(request: EventDetail.Model.CalendarRequest(event: event)) { [weak self] _, error in
            guard error != nil, let self = self else {
                self?.calendarStatus = .success
                return
            }
            self.calendarStatus = .failure
        }
    }

    func handleEventDetailResponse(response: EventDetail.Model.Response) {
        let dynamicData = response.eventdetails
        let staticData = response.staticData

        let eventsHeaderViewData = headerData(response: response)
        let eventsDetailsSection = EventDetail.EventDetailSection(eventsDetailSectionTitle: staticData.eventDetailsSectionHeader,
                                                                  eventDetailSections: eventsDetailsSection(response: response))

        let eventShareData = EventDetail.ShareData(eventDetail: dynamicData,
                                                   eventFields: staticData)

        let mediaSection = EventDetail.MediaSection(mediaSectionTitle: staticData.mediaSectionHeader,
                                                    mediaItems: convertToMediaData(mediaItems: dynamicData.media,
                                                                                   staticData: staticData))

        let registrationButtonData = EventDetail.RegisterSection(registrationLink: dynamicData.registrationLink,
                                                                 registerationButtonTitle: staticData.registerButtonCta)

        let calendarData = CalendarEventData(eventId: eventId,
                                             startDate: eventShareData.startDateTime,
                                             endDate: eventShareData.endDateTime,
                                             title: eventShareData.title,
                                             location: eventShareData.locationOrAddress,
                                             description: eventShareData.description.replacingOccurrences(of: "\\n", with: "\n"))

        let viewModel = EventDetail.Model.ViewModel(eventsHeaderViewData: eventsHeaderViewData,
                                                    eventShareData: eventShareData,
                                                    eventDetailSection: eventsDetailsSection,
                                                    mediaSection: mediaSection,
                                                    registerButtonData: registrationButtonData,
                                                    calendarEventData: calendarData,
                                                    staticData: response.staticData)

        convertToAnalyticsData(data: dynamicData)

        state = .success(viewModel)
    }

    func alertInfo(staticData: EventDetailFields) -> CustomAlertData {
        var customAlertData = CustomAlertData()
        if calendarAuthorization == .authorized { // showCalendarAlert {
            customAlertData.title = staticData.addToiphoneCalendarRequestTitle
            customAlertData.message = staticData.addToCalendarRequestDescription
            customAlertData.primaryButtonText = staticData.addToCalendarCancelCta
            customAlertData.secondaryButtonText = staticData.addToCalendarAddCta
        } else {
            customAlertData.title = staticData.calendarPermissionsNeededTitle
            customAlertData.message = staticData.calendarPermissionsNeededDescription
            customAlertData.primaryButtonText = staticData.calendarPermissionsCancelCta
            customAlertData.secondaryButtonText = staticData.calendarPermissionsSettingsCta
        }
        return customAlertData
    }

    func saveEvent(isSaved: Bool) {
        interactor.saveEvent(request: SaveEventRequest(eventId: eventId,
                                                       isSaved: isSaved,
                                                       individualEvent: true))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case let .failure(error):
                    self.handleSaveEventFailure(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.handleSaveEventSuccess(response: response)
            })
            .store(in: &cancellables)
    }
}

private extension EventDetailPresenter {
    func headerData(response: EventDetail.Model.Response) -> EventDetailHeaderView.ViewData {
        let dynamicData = response.eventdetails
        let staticData = response.staticData
        return EventDetailHeaderView.ViewData(headerImage: dynamicData.heroImage?.url ?? "",
                                              title: dynamicData.title,
                                              description: dynamicData.eventDescription,
                                              viewMoreText: staticData.contentViewerExpandDescriptionCtaTitle,
                                              viewLessText: staticData.contentViewerCollapseDescriptionCtaTitle,
                                              isFavourite: dynamicData.isSaved)
    }

    func eventsDetailsSection(response: EventDetail.Model.Response) -> [EventDetailCell.ViewData] {
        let dynamicData = response.eventdetails
        let staticData = response.staticData
        var eventDetailSections: [EventDetailCell.ViewData] = []

        let isAboEvent = dynamicData.eventAudience == EventType.aboEvent.rawValue
        eventDetailSections.append(EventDetailCell.ViewData(title: isAboEvent ? staticData.eventAudienceAboOnly : staticData.eventAudiencePublic,
                                                            icon: EventDetailImageAsset.userEvent.image))

        if dynamicData.registrationRequired {
            eventDetailSections.append(EventDetailCell.ViewData(title: staticData.yesRegistrationRequired,
                                                                icon: EventDetailImageAsset.noRegRequired.image))
        } else {
            eventDetailSections.append(EventDetailCell.ViewData(title: staticData.noRegistrationRequired,
                                                                icon: EventDetailImageAsset.noRegRequired.image))
        }
        let eventStartTime = EventsOverview.getStartTime(startTime: dynamicData.eventStart ?? "")
        let eventEndTime = EventsOverview.getEndTime(endTime: dynamicData.eventEnd ?? "")
        let eventDuration = "\(eventStartTime) - \(eventEndTime)"
        let eventDescription = EventDetail.dayYearMonthAndDate(eventStart: dynamicData.eventStart,
                                                               staticData: staticData)

        eventDetailSections.append(EventDetailCell.ViewData(title: "\(eventDescription)\n\(eventDuration)",
                                                            icon: EventDetailImageAsset.calendar.image,
                                                            cta: staticData.dateAddToCalendarCta,
                                                            actionType: .addToCalendar))

        if dynamicData.virtualEvent {
            eventDetailSections.append(EventDetailCell.ViewData(title: dynamicData.location,
                                                                icon: EventDetailImageAsset.map.image))
        } else {
            eventDetailSections.append(EventDetailCell.ViewData(title: dynamicData.address,
                                                                icon: EventDetailImageAsset.map.image,
                                                                cta: staticData.locationMapCta,
                                                                actionType: .getDirections))
        }
        return eventDetailSections
    }

    func convertToMediaData(mediaItems: [EventsMediaContentDataModel],
                            staticData: EventDetailFields) -> [EventsMediaCell.MediaData]
    {
        return mediaItems.map { mediaItem in
            let content = mediaItem.contentFile?.contentType ?? mediaItem.thumbnailImage?.contentType
            let contentType = content?.components(separatedBy: Constants.contentCategorySeperator.rawValue).first ?? ""
            let contentTypeLastPart = content?.components(separatedBy: Constants.contentCategorySeperator.rawValue).last ?? ""
            let isMediaTypePdf = contentTypeLastPart == MediaType.pdf.rawValue
            let isContentTypeVideo = contentType == MediaType.video.rawValue
            let mediaTypeImageOrVideo: MediaType = isContentTypeVideo ? .video : .image
            let mediaType: MediaType = isMediaTypePdf ? .pdf : mediaTypeImageOrVideo
            let videoShareUrl = mediaItem.videoShareLink.isEmpty ? mediaItem.contentFile?.url : mediaItem.videoShareLink
            let shareUrl = mediaType == .video ? videoShareUrl : ""

            return EventsMediaCell.MediaData(mediaType: mediaType,
                                             mediaURL: mediaItem.contentFile?.url ?? "",
                                             mediaTitle: mediaItem.description,
                                             shareURL: shareUrl ?? "",
                                             thumbnailURL: mediaItem.thumbnailImage?.url ?? "",
                                             shareTitle: staticData.mediaShareCTATitle,
                                             contentId: mediaItem.uid)
        }
    }

    func handleSaveEventFailure(error: Error) {
        DispatchQueue.main.async {
            switch error.localizedDescription {
            case CommonServiceError.internetFailure.localizedDescription:
                self.state = .failure(.internet)
            default:
                // On Save Event Failure, show failure toast and fetch event from local.
                self.displaySaveEventFailureToast()
                self.fetchEventDetail(type: .preview)
            }
        }
    }

    func handleSaveEventSuccess(response: EventDetail.Model.Response) {
        DispatchQueue.main.async {
            self.handleEventDetailResponse(response: response)
        }
    }

    private enum Constants: String, Localizable {
        case contentCategorySeperator = "/"
    }
}

// MARK: - Toast related methods

extension EventDetailPresenter {
    func showCalendarToast(toastData: ToastView.ViewData) {
        calendarToastData = toastData
        showCalendarToast = true
    }

    func hideCalendarToast() {
        showCalendarToast = false
        calendarToastData = nil
    }

    func hideSaveEventFailureToast() {
        showSaveEventFailureToast = false
        saveEventFailureToastData = nil
    }

    private func displaySaveEventFailureToast() {
        let toastData = ToastView
            .ViewData(rect: .zero,
                      fetchError: true,
                      messageData: ToastView
                          .DisplayData(title: ConnectivityErrorConstants.apiErrorTitle.localized,
                                       type: .failure,
                                       toastDescription: ConnectivityErrorConstants.apiErrorSubtitle.localized))
        saveEventFailureToastData = toastData
        showSaveEventFailureToast = true
    }
}

// MARK: - Analytics

extension EventDetailPresenter {
    func convertToAnalyticsData(data: EventDetailDataModel) {
        analyticsInfo = EventDetail.Model.AnalyticsInfo(eventId: data.eventId,
                                                        eventTitle: data.title,
                                                        registrationRequired: data.registrationRequired,
                                                        virtualEvent: data.virtualEvent)
    }

    func trackAnalyticsEvent(eventName: EventsAnalytics, mediaId: String? = nil) {
        guard let analyticsInfo = analyticsInfo else { return }
        interactor.trackAnalyticsEvent(eventName: eventName,
                                       analyticsInfo: analyticsInfo,
                                       mediaId: mediaId)
    }
}

extension EventDetailPresenter {
    // MARK: - Open the webview with the URL.

    func openUrl(urlString: String) {
        router?.navigate(to: .openWebView(urlString: urlString))
    }

    func openShare(shareData: EventDetail.ShareData) {
        router?.navigate(to: .openShare(shareData: shareData))
    }

    func navigateToMediaScreen(data: EventsMediaCell.MediaData) {
        guard let analyticsInfo = analyticsInfo else { return }
        let analyticsData = interactor.getAnalyticsData(eventName: .shareMedia,
                                                        analyticsInfo: analyticsInfo,
                                                        mediaId: data.contentId)

        router?.navigate(to: .mediaView(data: data, analyticsData: analyticsData))
    }
}

// MARK: - MediaURLValidationAlertInfo

extension EventDetailPresenter {
    func mediaValidationAlertInfo(mediaType: MediaType) -> CustomAlertData {
        var customAlertData = CustomAlertData()
        let fields = interactor.fetchMediaValidationErrorFields()
        switch mediaType {
        case .image:
            customAlertData.title = fields?.imageErrorTitle ?? CommonConstants.noDataCS
            customAlertData.message = fields?.imageErrorMessage ?? CommonConstants.noDataCS
        case .video:
            customAlertData.title = fields?.videoErrorTitle ?? CommonConstants.noDataCS
            customAlertData.message = fields?.videoErrorMessage ?? CommonConstants.noDataCS
        case .pdf:
            customAlertData.title = fields?.pdfErrorTitle ?? CommonConstants.noDataCS
            customAlertData.message = fields?.pdfErrorMessage ?? CommonConstants.noDataCS
        }
        customAlertData.primaryButtonText = fields?.primaryActionText ?? CommonConstants.noDataCS
        return customAlertData
    }
}
