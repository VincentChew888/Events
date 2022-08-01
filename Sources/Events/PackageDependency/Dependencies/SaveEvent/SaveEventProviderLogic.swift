//
//  EventsDataProviderLogic.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine

public protocol SaveEventProviderLogic {
    /// responsible for saving/unsaving an event i.e setting the isSaved property of the event to true or false
    func saveEvent(request: SaveEventRequest) -> AnyPublisher<[EventDetailDataModel], Error>
}
