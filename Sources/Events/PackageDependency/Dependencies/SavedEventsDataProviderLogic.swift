//
//  SavedEventsDataProviderLogic.swift
//
//
//  Created by Gautham on 16/06/22.
//

import Combine

/// The events provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol SavedEventsDataProviderLogic {
    /// responsible for providing dynamic api related data.
    /// - Parameters:
    ///     - type:  refer to EventsDataFetchType for documentation
    func fetchScheduledEvents(request: EventsFetchRequest,
                              type: EventsDataFetchType) -> AnyPublisher<[EventsOverviewDataModel], Error>

    /// responsible for providing static data eg. screen titles.
    func fetchSavedEventsFields() -> SavedEventsFields?
}
