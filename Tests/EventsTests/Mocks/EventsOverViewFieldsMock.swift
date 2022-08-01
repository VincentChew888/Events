//
//  EventsOverViewFieldsMock.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

@testable import Events

struct EventsOverViewFieldsMock: EventsOverViewFields {
    var eventCardDateTitle: EventCardDateTitleFields
    var screenTitle: String
    var emptyMonthDescription: String
    var unsavedEventIconURL: String
    var saveEventIconURL: String
    var saveEventErrorTitle: String
    var saveEventErrorDescription: String
    var savedEventScreenIconURL: String
    static func mockData() -> EventsOverViewFields {
        EventsOverViewFieldsMock(eventCardDateTitle: EventCardDateTitleFieldsMock(tomorrow: "tommorrow",
                                                                                  today: "today"),
                                 screenTitle: "",
                                 emptyMonthDescription: "",
                                 unsavedEventIconURL: "",
                                 saveEventIconURL: "",
                                 saveEventErrorTitle: "",
                                 saveEventErrorDescription: "",
                                 savedEventScreenIconURL: "")
    }
}

struct EventCardDateTitleFieldsMock: EventCardDateTitleFields {
    var tomorrow: String
    var today: String
}
