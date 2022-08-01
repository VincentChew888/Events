//
//  File.swift
//
//
//  Created by Amway on 15/06/22.
//

import Combine
import Foundation

protocol EventDetailBusinessLogic {
    func fetchEventDetail(request: EventDetail.Model.Request, type: EventsDataFetchType) -> AnyPublisher<EventDetail.Model.Response, Error>
    func fetchEventDetailFields() -> EventDetailFields?
    func fetchMediaValidationErrorFields() -> MediaValidationErrorFields?

    func save(request: EventDetail.Model.CalendarRequest, callback: ((Bool, Error?) -> Void)?)
    func getAuthorisationStatus(callback: @escaping (Bool) -> Void)
    func saveEvent(request: SaveEventRequest) -> AnyPublisher<EventDetail.Model.Response, Error>
    func trackAnalyticsEvent(eventName: EventsAnalytics, analyticsInfo: EventDetail.Model.AnalyticsInfo, mediaId: String?)
    func getAnalyticsData(eventName: EventsAnalytics, analyticsInfo: EventDetail.Model.AnalyticsInfo, mediaId: String?) -> AnalyticsData
}

final class EventDetailInteractor: EventDetailBusinessLogic {
    private var provider: EventDetailDataProviderLogic!
    private var saveEventProvider = PackageDependency.dependencies?.saveEventProvider
    private var cancellables = Set<AnyCancellable>()
    private var calendarEventStoreLogic: CalendarEventStoreProviderLogic

    init(provider: EventDetailDataProviderLogic,
         calendarEventStoreLogic: CalendarEventStoreProviderLogic)
    {
        self.provider = provider
        self.calendarEventStoreLogic = calendarEventStoreLogic
    }

    func fetchEventDetail(request: EventDetail.Model.Request, type: EventsDataFetchType) -> AnyPublisher<EventDetail.Model.Response, Error> {
        return Future<EventDetail.Model.Response, Error> { [weak self] promise in
            guard let self = self,
                  let eventStaticData = self.provider.fetchEventDetailFields()
            else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchScheduledEvent(request: request, type: type)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: {
                    promise(.success(EventDetail.Model.Response(eventdetails: $0,
                                                                staticData: eventStaticData)))
                }
                .store(in: &self.cancellables)

        }.eraseToAnyPublisher()
    }

    func getAuthorisationStatus(callback: @escaping (Bool) -> Void) {
        calendarEventStoreLogic.getAuthorisationStatus(callback: callback)
    }

    func save(request: EventDetail.Model.CalendarRequest, callback: ((Bool, Error?) -> Void)?) {
        calendarEventStoreLogic.save(event: request.event, callback: callback)
    }

    func fetchEventDetailFields() -> EventDetailFields? {
        provider.fetchEventDetailFields()
    }

    func saveEvent(request: SaveEventRequest) -> AnyPublisher<EventDetail.Model.Response, Error> {
        return Future<EventDetail.Model.Response, Error> { [weak self] promise in
            guard let self = self,
                  let eventStaticData = self.provider.fetchEventDetailFields()
            else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.saveEventProvider?.saveEvent(request: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { eventsList in
                    guard let event = eventsList.first else {
                        return promise(.failure(CommonServiceError.emptyData))
                    }

                    promise(.success(EventDetail.Model.Response(eventdetails: event,
                                                                staticData: eventStaticData)))
                }
                .store(in: &self.cancellables)

        }.eraseToAnyPublisher()
    }

    func trackAnalyticsEvent(eventName: EventsAnalytics, analyticsInfo: EventDetail.Model.AnalyticsInfo, mediaId: String?) {
        let analyticsData = getAnalyticsData(eventName: eventName, analyticsInfo: analyticsInfo, mediaId: mediaId)

        PackageDependency.dependencies?.analyticsTracker?.action(.analytics(event: analyticsData))
    }

    func getAnalyticsData(eventName: EventsAnalytics, analyticsInfo: EventDetail.Model.AnalyticsInfo, mediaId: String?) -> AnalyticsData {
        let registrationRequired = analyticsInfo.registrationRequired ? AnalyticsConstant.trueString : AnalyticsConstant.falseString
        let virtualEvent = analyticsInfo.virtualEvent ? AnalyticsConstant.trueString : AnalyticsConstant.falseString

        let analyticsData = AnalyticsData(name: eventName.rawValue,
                                          eventId: analyticsInfo.eventId,
                                          eventTitle: analyticsInfo.eventTitle,
                                          registrationRequired: registrationRequired,
                                          virtualEvent: virtualEvent,
                                          mediaId: mediaId)

        return analyticsData
    }

    func fetchMediaValidationErrorFields() -> MediaValidationErrorFields? {
        provider.fetchMediaValidationErrorFields()
    }
}
