//
//  File.swift
//
//
//  Created by Amway on 16/06/22.
//

import Combine

public protocol EventDetailDataProviderLogic {
    /// responsible for providing dynamic api related data.
    /// - Parameters:
    ///     - type:  refer to EventsDataFetchType for documentation
    func fetchScheduledEvent(request: EventDetail.Model.Request,
                             type: EventsDataFetchType) -> AnyPublisher<EventDetailDataModel, Error>
    /// responsible for providing static data eg. screen titles.
    func fetchEventDetailFields() -> EventDetailFields?

    /// responsible for providing static data for mediaValidationError Alert eg. image/pdf cannot be open
    func fetchMediaValidationErrorFields() -> MediaValidationErrorFields?
}
