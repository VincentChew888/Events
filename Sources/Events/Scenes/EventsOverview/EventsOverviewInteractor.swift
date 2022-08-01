//
//  EventsOverviewInteractor.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import Combine
import CommonInteractions
import Foundation

protocol EventsOverviewBusinessLogic {
    func fetchEvents(request: EventsOverview.Model.Request, type: EventsDataFetchType) -> AnyPublisher<EventsOverview.Model.Response, Error>
    func fetchEventsFields() -> EventsOverViewFields?
    func saveEvent(request: SaveEventRequest) -> AnyPublisher<EventsOverview.Model.Response, Error>
    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: EventsData)
}

final class EventsOverviewInteractor: EventsOverviewBusinessLogic, EventsOverviewDataStore {
    private var provider: EventsDataProviderLogic!
    private var saveEventProvider = PackageDependency.dependencies?.saveEventProvider
    private var cancellables = Set<AnyCancellable>()

    init(provider: EventsDataProviderLogic) {
        self.provider = provider
    }

    func fetchEvents(request: EventsOverview.Model.Request, type: EventsDataFetchType) -> AnyPublisher<EventsOverview.Model.Response, Error> {
        return Future<EventsOverview.Model.Response, Error> { [weak self] promise in
            guard let self = self,
                  let eventsStaticData = self.provider.fetchEventsFields()
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
                } receiveValue: {
                    promise(.success(EventsOverview.Model.Response(events: $0,
                                                                   model: eventsStaticData)))
                }
                .store(in: &self.cancellables)

        }.eraseToAnyPublisher()
    }

    func fetchEventsFields() -> EventsOverViewFields? {
        provider.fetchEventsFields()
    }

    func saveEvent(request: SaveEventRequest) -> AnyPublisher<EventsOverview.Model.Response, Error> {
        return Future<EventsOverview.Model.Response, Error> { [weak self] promise in
            guard let self = self else { return }

            self.saveEventProvider?.saveEvent(request: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { value in
                    guard let eventsStaticData = self.provider.fetchEventsFields() else {
                        return promise(.failure(CommonServiceError.invalidDataInFile))
                    }

                    promise(.success(EventsOverview.Model
                            .Response(events: value,
                                      model: eventsStaticData)))
                }
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

extension EventsOverviewInteractor {
    func trackAnalyticsEvent(eventName: EventsAnalytics, eventData: EventsData) {
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
