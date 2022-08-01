//
//  EventsOverviewPresenter.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import Combine
import Foundation

final class EventsOverviewPresenter: ObservableObject {
    private var interactor: EventsOverviewBusinessLogic
    private var router: EventsOverviewRouter?
    private var cancellables = Set<AnyCancellable>()

    private var isAPICallInProgress = false
    private(set) var appStateForegroundNotification = ApplicationWillEnterForegroundManager()

    init(interactor: EventsOverviewBusinessLogic) {
        self.interactor = interactor
    }

    // MARK: Injection

    func setRouter(_ router: EventsOverviewRouter) {
        self.router = router
    }

    enum State {
        case isLoading
        case failure(FailureType)
        case success(EventsOverview.Model.ViewModel)
    }

    enum FailureType {
        case connectivity
        case internet
    }

    @Published var state = State.isLoading
}

extension EventsOverviewPresenter {
    func fetchEvents(request: EventsOverview.Model.Request, type: EventsDataFetchType) {
        // Convert  response of Interactor to ViewModel.
        guard !isAPICallInProgress else { return }
        isAPICallInProgress = true
        interactor.fetchEvents(request: request, type: type)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isAPICallInProgress = false
                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            self.state = .failure(.internet)
                        default:
                            self.state = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleEventsResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    func fetchTitle() -> String {
        interactor.fetchEventsFields()?.screenTitle ?? ""
    }

    func eventsSection(response: EventsOverview.Model.Response) -> [EventsSection] {
        return EventsOverview.sections(using: response.events, staticData: response.model)
    }

    func handleEventsResponse(response: EventsOverview.Model.Response) {
        let eventsSection = self.eventsSection(response: response)
        let segmentsData = self.segmentsData()
        let segmentListData = SegmentListViewBuilder()
            .setSegmentsData(segmentsData: segmentsData)
            .build()
        let viewModel = EventsOverview.Model
            .ViewModel(sections: eventsSection,
                       segmentListData: segmentListData)
        state = .success(viewModel)
    }

    func segmentsData() -> [SegmentListViewBuilder.SegmentData] {
        var segmentsData: [SegmentListViewBuilder.SegmentData] = []
        for index in 0 ..< Constants.numberOfYears * Constants.lastMonthIndex {
            let monthDate = Date().getMonth(byAdding: index) ?? Date()
            let startOfMonth = monthDate.startOfMonth() ?? Date()
            var monthName = monthDate.monthString()

            if index != 0,
               Calendar.current.component(.month, from: monthDate) == 1
            {
                // For January of Next Year, set monthTitle using format "yyyy MMM"(Eg:- 2023 Jan)
                let nextYearFirstMonthName = monthDate.dateStringWithISOFormatAndLocaleCheck(using: DateFormat.yearSpaceShorthandMonth)
                monthName = nextYearFirstMonthName
            }
            segmentsData.append(SegmentListViewBuilder
                .SegmentData(title: monthName,
                             startOfMonth: startOfMonth))
        }
        return segmentsData
    }

    func saveEvent(request: SaveEventRequest) {
        interactor.saveEvent(request: request)
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

// MARK: Private methods

private extension EventsOverviewPresenter {
    func handleSaveEventFailure(error: Error) {
        DispatchQueue.main.async {
            switch error.localizedDescription {
            case CommonServiceError.internetFailure.localizedDescription:
                self.state = .failure(.internet)
            default:
                // On Save Event Failure, show failure toast and fetch events from local.
                self.showFailureToastInApp()
                self.fetchEvents(request: EventsOverview.Model.Request(),
                                 type: .preview)
            }
        }
    }

    func handleSaveEventSuccess(response: EventsOverview.Model.Response) {
        DispatchQueue.main.async {
            self.handleEventsResponse(response: response)
        }
    }

    /// Method to post a local notification to show toast. The application receives this notification and shows the toast,
    func showFailureToastInApp() {
        let toastViewData = ToastView.ViewData(rect: .zero,
                                               fetchError: true,
                                               messageData: ToastView
                                                   .DisplayData(title: ConnectivityErrorConstants.apiErrorTitle.localized,
                                                                type: .failure,
                                                                toastDescription: ConnectivityErrorConstants.apiErrorSubtitle.localized))
        let notificationName = NSNotification.Name(rawValue: ToastNotificationConstants.notificationName)
        let toastViewDataKey = ToastNotificationConstants.toastViewDataKey
        let eventsScreenTypeKey = ToastNotificationConstants.eventsScreenTypeKey
        let userInfoDict: [String: Any]
        userInfoDict = [toastViewDataKey: toastViewData,
                        eventsScreenTypeKey: EventsScreenType.overview.rawValue]
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: userInfoDict)
    }
}

extension EventsOverviewPresenter {
    enum Constants {
        static let lastMonthIndex: Int = 12
        static let numberOfYears: Int = 1
    }
}

// MARK: - Analytics

extension EventsOverviewPresenter {
    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: EventsData) {
        interactor.trackAnalyticsEvent(eventName: eventName, eventData: eventData)
    }
}

// MARK: - Routing

extension EventsOverviewPresenter {
    func routeToEventDetails(eventId: String) {
        router?.navigate(to: .detailsScreen(eventId: eventId))
    }
}
