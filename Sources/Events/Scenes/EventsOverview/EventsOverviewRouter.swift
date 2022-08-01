//
//  EventsOverviewRouter.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol EventsOverviewDataPassing {
    var dataStore: EventsOverviewDataStore? { get }
}

struct EventsOverviewRouter: EventsOverviewDataPassing {
    private var navigator: EventsRoutingLogic
    private(set) var dataStore: EventsOverviewDataStore?

    init(navigator: EventsRoutingLogic,
         dataStore: EventsOverviewDataStore)
    {
        self.navigator = navigator
        self.dataStore = dataStore
    }
}

extension EventsOverviewRouter: RoutingLogic {
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
