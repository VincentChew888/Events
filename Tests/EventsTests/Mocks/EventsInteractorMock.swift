//
//  EventsInteractorMock.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import Foundation

class EventsInteractorMock: EventsOverviewBusinessLogic {
    var success = false

    func fetchEvents(request _: EventsOverview.Model.Request,
                     type _: EventsDataFetchType) -> AnyPublisher<EventsOverview.Model.Response, Error>
    {
        if success {
            return Just(EventsOverview.Model.Response(events: [],
                                                      model: EventsOverViewFieldsMock.mockData()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<EventsOverview.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
            )
        }
    }

    func fetchEventsFields() -> EventsOverViewFields? {
        return EventsOverViewFieldsMock.mockData()
    }

    func saveEvent(request _: SaveEventRequest) -> AnyPublisher<EventsOverview.Model.Response, Error> {
        if success {
            return Just(EventsOverview.Model.Response(events: [],
                                                      model: EventsOverViewFieldsMock.mockData()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<EventsOverview.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
            )
        }
    }

    func trackAnalyticsEvent(eventName _: EventsAnalytics, eventData _: EventsData) {}
}
