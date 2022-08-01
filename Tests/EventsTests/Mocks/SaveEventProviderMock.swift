//
//  SaveEventProviderMock.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events

final class SaveEventProviderMock: SaveEventProviderLogic {
    var success = false

    func saveEvent(request _: SaveEventRequest) -> AnyPublisher<[EventDetailDataModel], Error> {
        if success {
            return Just([EventDetail.mockEvent()])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<[EventDetailDataModel], Error>(error: CommonServiceError.internetFailure)
            )
        }
    }
}
