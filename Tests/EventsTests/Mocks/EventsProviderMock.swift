//
//  EventsProviderMock.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import Foundation

class EventsProviderMock: EventsDataProviderLogic, SavedEventsDataProviderLogic {
    var success = false

    func fetchEventsFields() -> EventsOverViewFields? {
        if success {
            return EventsOverViewFieldsMock.mockData()
        } else {
            return nil
        }
    }

    func fetchScheduledEvents(request _: EventsFetchRequest,
                              type _: EventsDataFetchType) -> AnyPublisher<[EventsOverviewDataModel], Error>
    {
        if success {
            return Just(EventsOverview.mockData())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<[EventsOverviewDataModel], Error>(error: CommonServiceError.internetFailure)
            )
        }
    }

    func fetchSavedEventsFields() -> SavedEventsFields? {
        return success ? SavedEventsFieldsMock.mockData() : nil
    }
}
