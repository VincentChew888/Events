//
//  EventsOverviewConstants.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import CommonInteractions

/// All dependencies that are required to be initialized once and passed down to the providers should be held here.
public struct PackageDependencyContainer {
    public var eventDetailProvider: EventDetailDataProviderLogic?
    public var externalInteractions: ExternalApplicationLogic?
    public var eventsOverviewProvider: EventsDataProviderLogic?
    public var eventsOverviewRouter: EventsRoutingLogic?
    public var savedEventsRouter: SavedEventRoutingLogic?
    public var savedEventsProvider: SavedEventsDataProviderLogic?
    public var analyticsTracker: CreatorsAction?
    public var calendarEventStoreLogic: CalendarEventStoreProviderLogic?

    public var errorDataProvider: ErrorDataProviderLogic?
    public var saveEventProvider: SaveEventProviderLogic?
}

public enum PackageDependency {
    public static var dependencies: PackageDependencyContainer? {
        return packageDependencies
    }

    private static var packageDependencies: PackageDependencyContainer = PackageDependencyContainer()

    public static func setEventsProvider(provider: EventsDataProviderLogic) {
        packageDependencies.eventsOverviewProvider = provider
    }

    public static func setEventsRouter(router: EventsRoutingLogic) {
        packageDependencies.eventsOverviewRouter = router
    }

    public static func setSavedEventsRouter(router: SavedEventRoutingLogic) {
        packageDependencies.savedEventsRouter = router
    }

    public static func setEventDetailProvider(provider: EventDetailDataProviderLogic, calendarEventStoreLogic: CalendarEventStoreProviderLogic) {
        packageDependencies.eventDetailProvider = provider
        packageDependencies.calendarEventStoreLogic = calendarEventStoreLogic
    }

    public static func setExternalInteraction(router: ExternalApplicationLogic) {
        packageDependencies.externalInteractions = router
    }

    public static func setSavedEventsProvider(provider: SavedEventsDataProviderLogic) {
        packageDependencies.savedEventsProvider = provider
    }

    public static func setAnalyticsTracker(tracker: CreatorsAction) {
        packageDependencies.analyticsTracker = tracker
    }

    public static func setErrorDataProvider(errorDataProviderLogic: ErrorDataProviderLogic) {
        packageDependencies.errorDataProvider = errorDataProviderLogic
    }

    public static func setSaveEventProvider(provider: SaveEventProviderLogic) {
        packageDependencies.saveEventProvider = provider
    }
}
