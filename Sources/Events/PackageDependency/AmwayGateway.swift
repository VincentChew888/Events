//
//  EventsOverviewConstants.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import CommonInteractions
import Foundation

/// The AmwayGateway facilitate creation of EventsOverview Screen with injection of dependencies from the app
/// This helps provide proper separation of concerns between app and events package.
public enum AmwayGateway {
    /// creates EventsOverview after getting all dependencies from the app.
    /// - Parameters:
    ///     - theme:  refer to AmwayThemeKit: (https://www.notion.so/ymedialabs/AmwayThemeKit-72fa1419e421481c99527db59f043a61)
    ///     - provider:  refer to EventsDataProviderLogic documentation
    ///     - router:  refer to EventsRoutingLogic documentation
    public static func makeEventsOverview(theme: Theme,
                                          provider: EventsDataProviderLogic,
                                          router: EventsRoutingLogic) ->
        EventsOverviewView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
        injectEventsProvider(provider)
        injectEventsRouter(router)

        let interactor = EventsOverviewInteractor(provider: provider)
        let presenter = EventsOverviewPresenter(interactor: interactor)

        let view = EventsOverviewView(presenter: presenter)
        let eventsOverviewRouter = EventsOverviewRouter(navigator: router,
                                                        dataStore: interactor)

        presenter.setRouter(eventsOverviewRouter)
        return view
    }

    /// pass depdendencies for external routing to other application eg. settings application of iPhone.
    public static func makeExternalAppInteractions(externalApplicationLogic: ExternalApplicationLogic, externalInteraction: CreatorsAction)
    {
        injectExtenralInteractions(externalApplicationLogic)
        PackageDependency.setAnalyticsTracker(tracker: externalInteraction)
    }

    public static func makeSavedEvents(provider: SavedEventsDataProviderLogic,
                                       router: SavedEventRoutingLogic) -> SavedEventsView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.

        injectSavedEventsProvider(provider)
        injectSavedEventsRouter(router)
        let interactor = SavedEventsInteractor(provider: provider)
        let presenter = SavedEventsPresenter(interactor: interactor)

        let view = SavedEventsView(presenter: presenter)

        let savedEventsRouter = SavedEventsRouter(navigator: router,
                                                  dataStore: interactor)

        presenter.setRouter(savedEventsRouter)

        return view
    }

    private static func injectEventsProvider(_ provider: EventsDataProviderLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setEventsProvider(provider: provider)
    }

    private static func injectSavedEventsProvider(_ provider: SavedEventsDataProviderLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setSavedEventsProvider(provider: provider)
    }

    private static func injectEventsRouter(_ router: EventsRoutingLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setEventsRouter(router: router)
    }

    private static func injectSavedEventsRouter(_ router: SavedEventRoutingLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setSavedEventsRouter(router: router)
    }

    private static func injectExtenralInteractions(_ router: ExternalApplicationLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setExternalInteraction(router: router)
    }
}

extension AmwayGateway {
    /// creates EventDetailview after getting all dependencies from the app.
    /// - Parameters:
    ///     - theme:  refer to AmwayThemeKit: (https://www.notion.so/ymedialabs/AmwayThemeKit-72fa1419e421481c99527db59f043a61)
    ///     - provider:  refer to EventDetailDataProviderLogic documentation
    public static func makeEventDetail(theme: Theme,
                                       provider: EventDetailDataProviderLogic,
                                       router: EventDetailRoutingLogic,
                                       calendarEventStoreLogic: CalendarEventStoreProviderLogic) ->
        EventDetailView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
        injectEventDetailProvider(provider,
                                  calendarEventStoreLogic: calendarEventStoreLogic)
        let interactor = EventDetailInteractor(provider: provider,
                                               calendarEventStoreLogic: calendarEventStoreLogic)

        let eventDetailRouter = EventDetailRouter(navigator: router)
        let presenter = EventDetailPresenter(interactor: interactor)
        presenter.setRouter(eventDetailRouter)

        let view = EventDetailView(presenter: presenter)

        return view
    }

    private static func injectEventDetailProvider(_ provider: EventDetailDataProviderLogic, calendarEventStoreLogic: CalendarEventStoreProviderLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setEventDetailProvider(provider: provider,
                                               calendarEventStoreLogic: calendarEventStoreLogic)
    }
}
