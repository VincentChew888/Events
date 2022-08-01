//
//  SavedEventsFields.swift
//
//
//  Created by Gautham on 16/06/22.
//

import Foundation

///  Used in SavedEventsDataProviderLogic to get dynamic api  data from app to this package.
///  Actual implementation of this protocol shall reside in application side
public protocol SavedEventsFields {
    var title: String { get }
    var eventCardSectionTitle: String { get }
    var emptySavedEventsCardTitle: String { get }
    var emptySavedEventsCardDescription: String { get }
    var emptySavedEventsCardIcon: String { get }
    var savedEventIcon: String { get }
    var loadingErrorTitle: String { get }
    var loadingErrorDescription: String { get }
}
