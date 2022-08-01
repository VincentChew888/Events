//
//  EventDetailView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

public struct EventDetailView: View {
    enum Constants {
        static let mainBottomPadding: CGFloat = 16

        static let eventDetailHorizontalPadding: CGFloat = 12
        static let eventDetailTopPadding: CGFloat = 24
        static let eventDetailBottomPadding: CGFloat = 16

        static let toastHorizontalPadding: CGFloat = 16
        static let toastXPosition: CGFloat = 0
        static let toastTopPadding: CGFloat = 16

        static let backButtonTopPadding: CGFloat = 16
        static let backButtonXPosition: CGFloat = 16
    }

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject private var presenter: EventDetailPresenter

    @State private var showAlert = false
    @State private var mediaAlertInfo = EventDetail.MediaAlertInfo()

    private let externalInteractions = PackageDependency.dependencies?.externalInteractions

    init(presenter: EventDetailPresenter) {
        self.presenter = presenter
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: presenter.showCalendarToast || presenter.showSaveEventFailureToast ? .top : .center) {
            Theme.current.backgroundGray.color.edgesIgnoringSafeArea(.all)
            switch presenter.state {
            case .isLoading:
                EventsDetailShimmerSUIView(show: .constant(true))
                    .onAppear {
                        fetchEventDetail()
                    }
                    .overlay(backButton, alignment: .topLeading)
            case let .failure(type):
                switch type {
                case .connectivity:
                    EventDetailsConnectivityErrorView(presenter: presenter)
                        .overlay(backButton, alignment: .topLeading)
                case .internet:
                    ExtractedInternetErrorView {
                        presenter.fetchEventDetail(type: .refresh)
                    }
                    .overlay(backButton, alignment: .topLeading)
                }
            case let .success(viewModel):
                ZStack {
                    Theme.current.backgroundGray.color
                    VStack {
                        RefreshableScrollView(showsIndicators: false, loaderOffset: safeAreaInsets.top) { refreshComplete in
                            presenter.fetchEventDetail(type: .refresh,
                                                       completionHandler: refreshComplete)
                        } content: {
                            VStack(spacing: 0) {
                                EventDetailHeaderView(viewData: viewModel.eventsHeaderViewData,
                                                      shareData: viewModel.eventShareData,
                                                      actionPerformed: actionPerformed)
                                EventDetailSection(eventsDetailSectionTitle: viewModel.eventDetailSection.eventsDetailSectionTitle,
                                                   eventDetailSection: viewModel.eventDetailSection.eventDetailSections,
                                                   didTapOnContentButton: { type in
                                                       didTapOnContentButtons(type, location: viewModel.calendarEventData.location)
                                                   })
                                                   .alert(isPresented: $showAlert,
                                                          data: presenter.alertInfo(staticData: viewModel.staticData),
                                                          primaryButtonAction: {},
                                                          secondaryButtonAction: {
                                                              didTapOnSaveEvent(calendarEventData: viewModel.calendarEventData)
                                                              handleCalendarUpdateCompletionBlock(staticData: viewModel.staticData)
                                                          })
                                                   .padding([.leading, .trailing], Constants.eventDetailHorizontalPadding)
                                                   .padding(.top, Constants.eventDetailTopPadding)
                                                   .padding(.bottom, Constants.eventDetailBottomPadding)
                                if !viewModel.mediaSection.mediaItems.isEmpty {
                                    EventsMediaSection(title: viewModel.mediaSection.mediaSectionTitle,
                                                       items: viewModel.mediaSection.mediaItems) { item in
                                        presenter.trackAnalyticsEvent(eventName: .viewEventMedia, mediaId: item.contentId)
                                        guard item.mediaURL.isNotEmpty,
                                              let url = item.mediaURL.encodedURL(),
                                              UIApplication.shared.canOpenURL(url)
                                        else {
                                            mediaAlertInfo.showAlert = true
                                            mediaAlertInfo.mediaType = item.mediaType
                                            return
                                        }
                                        switch item.mediaType {
                                        case .pdf:
                                            presenter.openUrl(urlString: item.mediaURL)
                                        default:
                                            presenter.navigateToMediaScreen(data: item)
                                        }
                                    }
                                    .alert(isPresented: $mediaAlertInfo.showAlert,
                                           data: presenter.mediaValidationAlertInfo(mediaType: mediaAlertInfo.mediaType),
                                           primaryButtonAction: {},
                                           secondaryButtonAction: {})
                                }
                            }
                        }

                        if viewModel.registerButtonData.registrationLink.isNotEmpty {
                            let buttonData = AmwayButtonSUIBuilder()
                                .setTitle(viewModel.registerButtonData.registerationButtonTitle)
                                .build()
                            AmwayButtonSUI(data: buttonData) {
                                presenter.openUrl(urlString: viewModel.registerButtonData.registrationLink)
                                presenter.trackAnalyticsEvent(eventName: .registerForEvent)
                            }
                        }
                    }
                    .padding(.bottom, Constants.mainBottomPadding)
                }
                .onRefresh { _ in
                    fetchEventDetail()
                }
                .overlay(backButton, alignment: .topLeading)
                VStack {
                    if presenter.showCalendarToast,
                       let toastData = presenter.calendarToastData
                    {
                        ToastViewBuilder().build(viewData: toastData) {
                            presenter.hideCalendarToast()
                        }
                        .padding(.horizontal, Constants.toastHorizontalPadding)
                        .offset(x: Constants.toastXPosition, y: safeAreaInsets.top + Constants.toastTopPadding)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                presenter.hideCalendarToast()
                            }
                        }
                    }
                    if presenter.showSaveEventFailureToast,
                       let toastData = presenter.saveEventFailureToastData
                    {
                        ToastViewBuilder().build(viewData: toastData) {
                            presenter.showSaveEventFailureToast = false
                        }
                        .padding(.horizontal, Constants.toastHorizontalPadding)
                        .offset(x: Constants.toastXPosition, y: safeAreaInsets.top + Constants.toastTopPadding)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                presenter.showSaveEventFailureToast = false
                            }
                        }
                    }
                }
            }
        }.ignoresSafeArea(edges: .top)
            .onAppear {
                presenter.appStateForegroundNotification.addObserver {
                    presenter.fetchEventDetail(type: .refresh)
                }
            }
            .onDisappear {
                presenter.appStateForegroundNotification.removeObserver()
            }
    }

    public func setEventId(_ eventId: String) {
        presenter.setEventId(eventId)
    }

    public func fetchEventDetail() {
        presenter.fetchEventDetail(type: .initialLoad)
    }

    public func fetchScreenTitle() -> String {
        presenter.fetchTitle()
    }
}

// MARK: - Private

private extension EventDetailView {
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(EventDetailImageAsset.backArrowProgramDetail.rawValue)
        }
        .padding(.top, Constants.backButtonTopPadding)
        .offset(x: Constants.backButtonXPosition, y: safeAreaInsets.top)
    }

    var isConnectivityError: Bool {
        if case let .failure(value) = presenter.state {
            return value == .connectivity
        }
        return false
    }
}

extension EventDetailView {
    struct AlertData {
        var addToCalendarTitle: String
        var addToCalendarDesc: String
        var addEventButton: String
        var cancelButton: String
        var goToSettingsTitle: String
        var goToSettingsDescription: String
        var goToSettingsButton: String
    }
}

// MARK: - EventDetailHeaderView Actions

private extension EventDetailView {
    func actionPerformed(_ action: EventDetailHeaderView.Action) {
        switch action {
        case let .favourite(isSaved):
            presenter.saveEvent(isSaved: isSaved)
            presenter.trackAnalyticsEvent(eventName: .saveEvent)
        case let .share(shareData):
            presenter.openShare(shareData: shareData)
            presenter.trackAnalyticsEvent(eventName: .shareEvent)
        }
    }

    func didTapOnContentButtons(_ action: EventDetailCell.ActionType?, location: String? = nil) {
        guard let action = action else { return }

        switch action {
        case .getDirections:
            if let location = location {
                externalInteractions?.openUrl(urlString: EventDetailURL.appleMaps.rawValue + location.trimWhitespacesAndNewlines)
            }
            presenter.trackAnalyticsEvent(eventName: .getDirections)
        case .addToCalendar:
            presenter.authorizationStatus()
            showAlert = presenter.calendarAuthorization != .isLoading
            presenter.trackAnalyticsEvent(eventName: .addToCalendar)
        }
    }

    func didTapOnSaveEvent(calendarEventData: CalendarEventData) {
        switch presenter.calendarAuthorization {
        case .authorized:
            presenter.saveEvent(event: calendarEventData)
        case .denied:
            externalInteractions?.openSettings()
        default:
            break
        }
    }

    func handleCalendarUpdateCompletionBlock(staticData: EventDetailFields) {
        switch presenter.calendarStatus {
        case .success:
            let toastData = ToastView
                .ViewData(rect: .zero,
                          fetchError: false,
                          messageData: ToastView
                              .DisplayData(title: staticData.addToiphoneCalendarSuccessTitle,
                                           type: .success,
                                           toastDescription: staticData.addToCalendarSuccessDescription))
            presenter.showCalendarToast(toastData: toastData)
        case .failure:
            let toastData = ToastView
                .ViewData(rect: .zero,
                          fetchError: true,
                          messageData: ToastView
                              .DisplayData(title: ConnectivityErrorConstants.apiErrorTitle.localized,
                                           type: .failure,
                                           toastDescription: ConnectivityErrorConstants.apiErrorSubtitle.localized))
            presenter.showCalendarToast(toastData: toastData)
        default:
            break
        }
    }
}
