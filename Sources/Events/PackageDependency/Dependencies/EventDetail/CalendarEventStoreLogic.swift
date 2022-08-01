//
//  CalendarEventStore.swift
//
//
//  Created by Priyanka on 17/06/22.
//

import Foundation

public protocol CalendarEventStoreProviderLogic {
    func save(event: CalendarEventData, callback: ((Bool, Error?) -> Void)?)
    func getAuthorisationStatus(callback: @escaping (Bool) -> Void)
}
