//
//  SavedEventsFieldsMock.swift
//
//
//  Created by Gautham on 16/06/22.
//

@testable import Events
import Foundation

struct SavedEventsFieldsMock: SavedEventsFields {
    var title: String
    var eventCardSectionTitle: String
    var emptySavedEventsCardTitle: String
    var emptySavedEventsCardDescription: String
    var emptySavedEventsCardIcon: String
    var savedEventIcon: String
    var loadingErrorTitle: String
    var loadingErrorDescription: String

    static func mockData() -> SavedEventsFields {
        SavedEventsFieldsMock(title: "",
                              eventCardSectionTitle: "",
                              emptySavedEventsCardTitle: "",
                              emptySavedEventsCardDescription: "",
                              emptySavedEventsCardIcon: "",
                              savedEventIcon: "",
                              loadingErrorTitle: "",
                              loadingErrorDescription: "")
    }
}
