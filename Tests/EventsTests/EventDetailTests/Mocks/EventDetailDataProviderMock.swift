//
//  EventDetailDataProviderMock.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//
import Combine
@testable import Events

final class EventDetailDataProviderMock: EventDetailDataProviderLogic {
    var isSuccess = false
    func fetchScheduledEvent(request _: EventDetail.Model.Request, type _: EventsDataFetchType) -> AnyPublisher<EventDetailDataModel, Error> {
        if isSuccess {
            return Just(EventDetail.mockEvent())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return AnyPublisher(
                Fail<EventDetailDataModel, Error>(error: CommonServiceError.internetFailure)
            )
        }
    }

    func fetchEventDetailFields() -> EventDetailFields? {
        return isSuccess ? EventDetailFeildsMock.mockData() : nil
    }

    func fetchMediaValidationErrorFields() -> MediaValidationErrorFields? {
        return isSuccess ? MediaValidationErrorFieldsMock.mockData() : nil
    }
}
