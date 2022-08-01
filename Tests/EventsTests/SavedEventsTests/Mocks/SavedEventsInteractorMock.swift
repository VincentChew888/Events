//
//  SavedEventsInteractorMock.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events

class SavedEventsInteractorMock: SavedEventsBusinessLogic {
    var success = false

    func fetchSavedEvents(request _: SavedEvent.Model.Request,
                          type _: EventsDataFetchType) -> AnyPublisher<SavedEvent.Model.Response, Error>
    {
        if success {
            return Just(SavedEvent.Model.Response(events: [],
                                                  staticData: SavedEventsFieldsMock.mockData()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<SavedEvent.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
            )
        }
    }

    func fetchSavedEventsFields() -> SavedEventsFields? {
        return success ? SavedEventsFieldsMock.mockData() : nil
    }

    func saveEvent(request _: SaveEventRequest) -> AnyPublisher<SavedEvent.Model.Response, Error> {
        if success {
            return Just(SavedEvent.Model.Response(events: EventsOverview.mockData(),
                                                  staticData: SavedEventsFieldsMock.mockData()))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<SavedEvent.Model.Response, Error>(error: CommonServiceError.invalidDataInFile)
            )
        }
    }

    func trackAnalyticsEvent(eventName _: EventsAnalytics, eventData _: SavedEventsData) {}
}
