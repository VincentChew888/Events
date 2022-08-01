//
//  EventsRoutingLogic.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import CommonInteractions

/// The events router facilitate communication between the routing/Navigation from the this UI Layer package and the application navigation logic.
/// This helps provide proper separation of concerns between the UI Layer of this package and in app where it is been used.
public protocol EventsRoutingLogic {
    /// DetailsScreenNavigation
    /// - Parameters:
    ///     - type:  refer to EventsOverviewDataStore for documentation
    func navigateToDetailsScreen(eventId: String)

    /// WebView Navigation
    /// - Parameters:
    ///     - urlString:  link to be openedInWebView
    func navigateToWebView(urlString: String)

    /// Navigates to the Event Media screen
    /// - Parameter data: Event media data
    func navigateToMediaScreen(data: EventMediaDataModel, analyticsData: AnalyticsEvent)
}

/// Responsible for passing data from events package to screen where we are navigating.
/// EventsInteractor can pass appropriate data once it confirms to this protocol
public protocol EventsOverviewDataStore {}
