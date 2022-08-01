//
//  SavedEventsView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

public struct SavedEventsView: View {
    typealias AnalyticsEventCompletion = (EventsAnalytics, _ event: SavedEventsData) -> Void

    @ObservedObject private var presenter: SavedEventsPresenter

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: SavedEventsPresenter) {
        self.presenter = presenter
        UITableView.appearance(whenContainedInInstancesOf: [UIHostingController<SavedEventsView>.self]).backgroundColor = Theme.current.backgroundGray.uiColor
        UITableView.appearance(whenContainedInInstancesOf: [UIHostingController<SavedEventsView>.self]).separatorColor = .clear
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            Theme.current.backgroundGray.color.edgesIgnoringSafeArea(.all)
            switch presenter.state {
            case .isLoading:
                SavedEventsShimmerSUIView(show: .constant(true))
                    .onAppear {
                        fetchSavedEvents(type: .initialLoad)
                    }
            case let .failure(type):
                switch type {
                case .connectivity:
                    SavedEventsConnectivityErrorView(presenter: presenter)
                case .internet:
                    SavedEventsInternetErrorView {
                        fetchSavedEvents(type: .refresh)
                    }
                }

            case let .success(viewModel):
                if viewModel.events.isEmpty {
                    SavedEventsEmptyViewWithRefresh(viewData: presenter.emptyViewData) {
                        fetchSavedEvents(type: .refresh)
                    }
                } else {
                    SavedEventList(savedEvents: viewModel.events,
                                   headerTitle: viewModel.staticData.eventCardSectionTitle,
                                   didTapSaveButton: didTapOnSave(_:),
                                   analyticsEventCompletion: { eventName, event in
                                       presenter.trackAnalyticsEvent(eventName: eventName, eventData: event)
                                   },
                                   didTapEvent: didTapOnEvent(_:))
                        .onRefresh { _ in
                            fetchSavedEvents(type: .refresh)
                        }
                }
            }
        }
        .navigationTitle(presenter.fetchTitle())
        .introspectNavigationController { nav in
            nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        .onAppear {
            presenter.appStateForegroundNotification.addObserver {
                fetchSavedEvents()
            }
        }
        .onDisappear {
            presenter.appStateForegroundNotification.removeObserver()
        }
    }

    public func fetchScreenTitle() -> String {
        presenter.fetchTitle()
    }

    public func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    public func fetchSavedEvents(type: EventsDataFetchType = .refresh) {
        presenter.fetchSavedEvents(type: type)
    }
}

// MARK: Private methods

private extension SavedEventsView {
    func didTapOnSave(_ eventsData: SavedEventsData) {
        let request = SaveEventRequest(eventId: eventsData.eventId,
                                       isSaved: eventsData.isSaved,
                                       filterOnlySavedEvents: true)
        presenter.saveEvent(request: request)
    }

    func didTapOnEvent(_ eventsId: String) {
        presenter.routeToEventDetails(eventId: eventsId)
    }
}

private extension SavedEventsView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case backButtonSavedEvents
    }
}

struct SavedEventsConnectivityErrorView: View {
    @ObservedObject private var presenter: SavedEventsPresenter

    init(presenter: SavedEventsPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        VStack {
            ConnectivityErrorSUIView {
                presenter.fetchSavedEvents(type: .refresh)
            }
            .frame(height: 104)
            .padding([.leading, .trailing], 16)
            .padding([.top], 32)
            Spacer()
        }
    }
}

struct InternetErrorViewForSavedEvents: View {
    var body: some View {
        VStack {
            InternetErrorSUIView()
                .frame(height: 248)
                .padding([.leading, .trailing], 16)
                .padding([.top], 32)
            Spacer()
        }
    }
}

struct SavedEventsInternetErrorView: View {
    var refreshAction: (() -> Void)?
    let refreshControlViewData = AmwayRefreshControlBuilder()
        .setInnerCircleColor(Theme.current.loaderBackgroundColor.uiColor)
        .setOuterCircleColor(Theme.current.amwayWhite.uiColor)
        .build()
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                AmwayScrollView<InternetErrorViewForSavedEvents>(width: geometry.size.width,
                                                                 height: geometry.size.height,
                                                                 refreshControlViewData: refreshControlViewData,
                                                                 refreshAction: refreshAction) {
                    InternetErrorViewForSavedEvents()
                }
            }
        }
    }
}

struct SavedEventsEmptyViewWithRefresh: View {
    let refreshControlViewData = AmwayRefreshControlBuilder()
        .setInnerCircleColor(Theme.current.loaderBackgroundColor.uiColor)
        .setOuterCircleColor(Theme.current.amwayWhite.uiColor)
        .build()
    var viewData: ImageTitleSubTitleBuilder.ImageTitleSubtitleViewData
    var refreshAction: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            AmwayScrollView<SavedEventsEmptyView>(width: geometry.size.width,
                                                  height: geometry.size.height,
                                                  refreshControlViewData: refreshControlViewData,
                                                  refreshAction: refreshAction) {
                SavedEventsEmptyView(viewData: viewData)
            }
        }
    }
}

struct SavedEventsEmptyView: View {
    var viewData: ImageTitleSubTitleBuilder.ImageTitleSubtitleViewData

    var body: some View {
        VStack {
            ImageTitleSubtitleSUIView(viewData: viewData)
                .frame(height: 176.0 + viewData.getTitleAndDescriptionViewHeight(widthOffset: 64)) // Need to revisit frame modifier, here calculated manually to fix CW-4436
                .padding(.top, 32)
                .padding([.leading, .trailing], 16)
            Spacer()
        }
    }
}
