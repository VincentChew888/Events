//
//  EventDetailInteractorMock.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import Foundation

class EventDetailInteractorMock: EventDetailBusinessLogic {
    var success = false
    var eventId = ""
    var isVirtualMediaEvent = false
    var isInternetError = false
    var provider: EventDetailDataProviderMock!
    init(provider: EventDetailDataProviderMock) {
        self.provider = provider
    }

    func fetchEventDetail(request: EventDetail.Model.Request, type _: EventsDataFetchType) -> AnyPublisher<EventDetail.Model.Response, Error> {
        eventId = request.eventId
        if success {
            if isVirtualMediaEvent {
                return Just(EventDetail.Model.Response(eventdetails: EventDetail.virtualMediaEvent(),
                                                       staticData: EventDetailFeildsMock.mockData()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Just(EventDetail.Model.Response(eventdetails: EventDetail.mockEvent(),
                                                       staticData: EventDetailFeildsMock.mockData()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        } else {
            if isInternetError {
                return AnyPublisher(
                    Fail<EventDetail.Model.Response, Error>(error: CommonServiceError.internetFailure)
                )
            } else {
                return AnyPublisher(
                    Fail<EventDetail.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
                )
            }
        }
    }

    func fetchEventDetailFields() -> EventDetailFields? {
        return EventDetailFeildsMock.mockData()
    }

    func save(request _: EventDetail.Model.CalendarRequest, callback _: ((Bool, Error?) -> Void)?) {}

    func getAuthorisationStatus(callback _: @escaping (Bool) -> Void) {}

    func trackAnalyticsEvent(eventName _: EventsAnalytics, analyticsInfo _: EventDetail.Model.AnalyticsInfo, mediaId _: String?) {}

    func getAnalyticsData(eventName _: EventsAnalytics, analyticsInfo _: EventDetail.Model.AnalyticsInfo, mediaId _: String?) -> AnalyticsData {
        AnalyticsData(name: "",
                      eventId: "",
                      eventTitle: "",
                      registrationRequired: "",
                      virtualEvent: "")
    }

    func saveEvent(request _: SaveEventRequest) -> AnyPublisher<EventDetail.Model.Response, Error> {
        if success {
            return Just(EventDetail.Model.Response(eventdetails: EventDetail.mockEvent(),
                                                   staticData: EventDetailFeildsMock.mockData()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<EventDetail.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
            )
        }
    }

    func fetchMediaValidationErrorFields() -> MediaValidationErrorFields? {
        provider.isSuccess = success
        return provider.fetchMediaValidationErrorFields()
    }
}
