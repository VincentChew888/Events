//
//  SavedEventsRouter.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import UIKit

protocol SavedEventsDataPassing {
    var dataStore: SavedEventsDataStore? { get }
}

struct SavedEventsRouter: SavedEventsDataPassing {
    private(set) var dataStore: SavedEventsDataStore?
    private var navigator: SavedEventRoutingLogic

    init(navigator: SavedEventRoutingLogic,
         dataStore: SavedEventsDataStore)
    {
        self.dataStore = dataStore
        self.navigator = navigator
    }
}

extension SavedEventsRouter: RoutingLogic {
    enum Destination {
        case detailsScreen(eventId: String)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case let .detailsScreen(eventId):
            navigator.navigateToDetailsScreen(eventId: eventId)
        }
    }
}
