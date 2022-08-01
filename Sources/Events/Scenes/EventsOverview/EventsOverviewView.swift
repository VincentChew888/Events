//
//  EventsOverviewView.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import AmwayThemeKit
import SwiftUI

public struct EventsOverviewView: View {
    typealias AnalyticsEventCompletion = (EventsAnalytics, _ event: EventsData) -> Void

    @ObservedObject private var presenter: EventsOverviewPresenter
    @State private var topSectionStartOfMonth: Date = (Date().startOfMonth() ?? Date())

    // MARK: Injection

    init(presenter: EventsOverviewPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .center) {
            Theme.current.backgroundGray.color.edgesIgnoringSafeArea(.all)
            switch presenter.state {
            case .isLoading:
                EventsOverviewShimmerSUIView(show: .constant(true))
                    .onAppear {
                        presenter.fetchEvents(request: EventsOverview.Model.Request(), type: .initialLoad)
                    }
            case let .failure(type):
                switch type {
                case .connectivity:
                    ExtractedConnectivityErrorView(presenter: presenter)
                case .internet:
                    ExtractedInternetErrorView {
                        presenter.fetchEvents(request: EventsOverview.Model.Request(), type: .refresh)
                    }
                }
            case let .success(viewModel):
                ZStack {
                    Theme.current.darkPurple.color
                    VStack {
                        SegmentListView(viewData: viewModel.segmentListData,
                                        topSectionStartOfMonth: $topSectionStartOfMonth)
                        EventsListView(eventsSections: viewModel.sections,
                                       topSectionStartOfMonth: $topSectionStartOfMonth,
                                       didTapEvent: didTapOnEvent(_:),
                                       didTapSaveButton: didTapOnSave(_:),
                                       analyticsEventCompletion: { eventName, event in
                                           presenter.trackAnalyticsEvent(eventName: eventName, eventData: event)
                                       })
                                       .onRefresh { _ in
                                           fetchEvents()
                                       }
                    }
                }
            }
        }
        .navigationTitle(presenter.fetchTitle())
        .introspectNavigationController { nav in
            nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        .onAppear {
            presenter.appStateForegroundNotification.addObserver {
                presenter.fetchEvents(request: EventsOverview.Model.Request(), type: .refresh)
            }
        }
        .onDisappear {
            presenter.appStateForegroundNotification.removeObserver()
        }
    }

    public func fetchEvents() {
        presenter.fetchEvents(request: EventsOverview.Model.Request(), type: .refresh)
    }

    public func fetchScreenTitle() -> String {
        presenter.fetchTitle()
    }
}

// MARK: Private methods

private extension EventsOverviewView {
    func didTapOnSave(_ eventsData: EventsData) {
        let request = SaveEventRequest(eventId: eventsData.eventId,
                                       isSaved: eventsData.isSaved)
        presenter.saveEvent(request: request)
    }

    func didTapOnEvent(_ eventsId: String) {
        presenter.routeToEventDetails(eventId: eventsId)
    }
}

struct ExtractedConnectivityErrorView: View {
    @ObservedObject private var presenter: EventsOverviewPresenter
    var connectivityErrorButtonData: AmwayButtonBuilder.AmwayButtonColors
    var connectivityError: ConnectivityErrorViewBuilder.ConnectivityErrorData

    init(presenter: EventsOverviewPresenter) {
        self.presenter = presenter
        connectivityErrorButtonData = AmwayButtonBuilder.AmwayButtonColors(textColor: .white,
                                                                           backgroundColor: Theme.current.darkPurple.uiColor,
                                                                           tintColor: .white,
                                                                           borderColor: Theme.current.darkPurple.uiColor)
        connectivityError = ConnectivityErrorViewBuilder.ConnectivityErrorData(colors: connectivityErrorButtonData,
                                                                               textColor: .white,
                                                                               backgroundColor: Theme.current.darkPurple.uiColor)
    }

    var body: some View {
        ZStack {
            Theme.current.darkPurple.color.edgesIgnoringSafeArea(.all)
            VStack {
                ConnectivityErrorSUIView(customConnectivityErrorData: connectivityError, onTryAgain: {
                    presenter.fetchEvents(request: EventsOverview.Model.Request(), type: .refresh)
                })
                .frame(height: 104)
                .padding([.leading, .trailing], 16)
            }
        }
    }
}

struct InternetErrorViewForEvents: View {
    var internetErrorData = InternetErrorView.InternetErrorViewData(hideGlobeImage: true,
                                                                    titleTextColor: .white,
                                                                    subTitleTextColor: .white,
                                                                    backgroundColor: Theme.current.darkPurple.uiColor,
                                                                    title: "",
                                                                    subTitle: "",
                                                                    globeImage: nil)

    var body: some View {
        VStack {
            InternetErrorSUIView(customInternetErrorData: internetErrorData)
                .frame(height: 248)
                .padding([.leading, .trailing], 16)
        }
    }
}

struct ExtractedInternetErrorView: View {
    var refreshAction: (() -> Void)?
    var body: some View {
        ZStack {
            Theme.current.darkPurple.color.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                GeometryReader { geometry in
                    AmwayScrollView<InternetErrorViewForEvents>(width: geometry.size.width,
                                                                height: geometry.size.height,
                                                                refreshAction: refreshAction) {
                        InternetErrorViewForEvents()
                    }
                }
            }
        }
    }
}
