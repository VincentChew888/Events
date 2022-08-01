//
//  SavedEventsPresenter.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
import Foundation

final class SavedEventsPresenter: ObservableObject {
    private var interactor: SavedEventsBusinessLogic
    private var router: SavedEventsRouter?
    private var cancellables = Set<AnyCancellable>()
    private var isAPICallInProgress = false
    private(set) var appStateForegroundNotification = ApplicationWillEnterForegroundManager()

    init(interactor: SavedEventsBusinessLogic) {
        self.interactor = interactor
    }

    // MARK: Injection

    func setRouter(_ router: SavedEventsRouter) {
        self.router = router
    }

    enum State {
        case isLoading
        case failure(FailureType)
        case success(SavedEvent.Model.ViewModel)
    }

    enum FailureType {
        case connectivity
        case internet
    }

    @Published var state = State.isLoading
    @Published var emptyViewData = ImageTitleSubTitleBuilder().build()

    private var response: SavedEvent.Model.Response?
}

extension SavedEventsPresenter {
    func fetchSavedEvents(type: EventsDataFetchType) {
        guard !isAPICallInProgress else { return }
        isAPICallInProgress = true

        interactor.fetchSavedEvents(request: SavedEvent.Model.Request(isSavedEvents: true), type: type)
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
        interactor.fetchSavedEventsFields()?.title ?? ""
    }

    func handleEventsResponse(response: SavedEvent.Model.Response) {
        self.response = response
        let savedEvents = SavedEvent.constructViewModel(using: response.events)
        guard !savedEvents.isEmpty else {
            handleEmptyData(fields: response.staticData)
            return
        }
        let viewModel = SavedEvent.Model.ViewModel(events: savedEvents, staticData: response.staticData)
        state = .success(viewModel)
    }

    func saveEvent(request: SaveEventRequest) {
        removeUnsavedEventFromList(eventId: request.eventId)

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

private extension SavedEventsPresenter {
    func handleEmptyData(fields: SavedEventsFields) {
        loadImage(from: fields.emptySavedEventsCardIcon) { [weak self] result in
            guard case let .success(image) = result else {
                return
            }
            DispatchQueue.main.async {
                self?.emptyViewData = ImageTitleSubTitleBuilder()
                    .setTitle(fields.emptySavedEventsCardTitle)
                    .setSubTitle(fields.emptySavedEventsCardDescription)
                    .setImage(image)
                    .setButtonData(nil)
                    .setImageViewContentMode(.scaleAspectFit)
                    .setCornerRadius(12)
                    .build()
                self?.state = .success(SavedEvent.Model.ViewModel(events: [], staticData: fields))
            }
        }
    }

    func handleSaveEventFailure(error: Error) {
        DispatchQueue.main.async {
            switch error.localizedDescription {
            case CommonServiceError.internetFailure.localizedDescription:
                self.state = .failure(.internet)
            default:
                // On Save Event Failure, show failure toast and fetch saved events from local.
                self.showFailureToastInApp()
                self.fetchSavedEvents(type: .preview)
            }
        }
    }

    func handleSaveEventSuccess(response: SavedEvent.Model.Response) {
        DispatchQueue.main.async {
            self.handleEventsResponse(response: response)
        }
    }

    /// Method to remove the unsaved event from the list and update the UI
    /// - Parameter eventId: eventId of the unsaved event.
    func removeUnsavedEventFromList(eventId: String) {
        if var response = response,
           let index = response.events.firstIndex(where: { $0.eventId == eventId })
        {
            response.events.remove(at: index)
            handleEventsResponse(response: SavedEvent.Model
                .Response(events: response.events,
                          staticData: response.staticData))
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
                        eventsScreenTypeKey: EventsScreenType.savedEvents.rawValue]
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: userInfoDict)
    }
}

extension SavedEventsPresenter: ImageProvider {}

// MARK: - Analytics

extension SavedEventsPresenter {
    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: SavedEventsData) {
        interactor.trackAnalyticsEvent(eventName: eventName, eventData: eventData)
    }
}

// MARK: - Routing

extension SavedEventsPresenter {
    func routeToEventDetails(eventId: String) {
        router?.navigate(to: .detailsScreen(eventId: eventId))
    }
}
