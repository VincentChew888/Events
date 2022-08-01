//
//  EventsOverViewFields.swift
//  Events
//
//  Copyright © 2022 Amway. All rights reserved.
//

///  used in EventsDataProviderLogic to get static api  data from app to this package eg. screen title
///  Actual implementation of this protocol shall reside in application side
public protocol EventsOverViewFields {
    var screenTitle: String { get }
    var emptyMonthDescription: String { get }
    var unsavedEventIconURL: String { get }
    var saveEventIconURL: String { get }
    var saveEventErrorTitle: String { get }
    var saveEventErrorDescription: String { get }
    var savedEventScreenIconURL: String { get }
    var eventCardDateTitle: EventCardDateTitleFields { get }
}

public protocol EventCardDateTitleFields {
    var tomorrow: String { get }
    var today: String { get }
}
