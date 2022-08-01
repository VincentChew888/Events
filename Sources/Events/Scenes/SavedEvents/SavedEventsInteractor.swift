//
//  SavedEventsInteractor.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
import Foundation

protocol SavedEventsBusinessLogic {
    func fetchSavedEvents(request: SavedEvent.Model.Request, type: EventsDataFetchType) -> AnyPublisher<SavedEvent.Model.Response, Error>
    func fetchSavedEventsFields() -> SavedEventsFields?
    func saveEvent(request: SaveEventRequest) -> AnyPublisher<SavedEvent.Model.Response, Error>
    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: SavedEventsData)
}

protocol SavedEventsDataStore {}

final class SavedEventsInteractor: SavedEventsBusinessLogic, SavedEventsDataStore {
    private var provider: SavedEventsDataProviderLogic!
    private var saveEventProvider = PackageDependency.dependencies?.saveEventProvider
    private var cancellables = Set<AnyCancellable>()

    init(provider: SavedEventsDataProviderLogic) {
        self.provider = provider
    }

    func fetchSavedEvents(request: SavedEvent.Model.Request,
                          type: EventsDataFetchType) -> AnyPublisher<SavedEvent.Model.Response, Error>
    {
        return Future<SavedEvent.Model.Response, Error> { [weak self] promise in
            guard let self = self,
                  let eventsStaticData = self.fetchSavedEventsFields()
            else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }
            let request = EventsFetchRequest(isSavedEvents: request.isSavedEvents)

            self.provider.fetchScheduledEvents(request: request, type: type)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { promise(.success(SavedEvent.Model.Response(events: $0,
                                                                             staticData: eventsStaticData))) }
                .store(in: &self.cancellables)

        }.eraseToAnyPublisher()
    }

    func fetchSavedEventsFields() -> SavedEventsFields? {
        provider.fetchSavedEventsFields()
    }

    func saveEvent(request: SaveEventRequest) -> AnyPublisher<SavedEvent.Model.Response, Error> {
        return Future<SavedEvent.Model.Response, Error> { [weak self] promise in
            guard let self = self else { return }

            self.saveEventProvider?.saveEvent(request: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { value in
                    guard let savedEventsStaticData = self.fetchSavedEventsFields() else {
                        return promise(.failure(CommonServiceError.invalidDataInFile))
                    }

                    promise(.success(SavedEvent.Model
                            .Response(events: value,
                                      staticData: savedEventsStaticData)))
                }
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }

    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: SavedEventsData) {
        let registrationRequired = eventData.registrationRequired ? AnalyticsConstant.trueString : AnalyticsConstant.falseString
        let virtualEvent = eventData.virtualEvent ? AnalyticsConstant.trueString : AnalyticsConstant.falseString

        let analyticsData = AnalyticsData(name: eventName.rawValue,
                                          eventId: eventData.eventId,
                                          eventTitle: eventData.title,
                                          registrationRequired: registrationRequired,
                                          virtualEvent: virtualEvent)

        PackageDependency.dependencies?.analyticsTracker?.action(.analytics(event: analyticsData))
    }
}
