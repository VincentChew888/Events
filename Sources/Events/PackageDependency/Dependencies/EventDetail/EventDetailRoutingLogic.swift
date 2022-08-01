//
//  File.swift
//
//
//  Created by Amway on 22/06/22.
//

import CommonInteractions
import Foundation

/// The event detail router facilitate communication between the routing/Navigation from the this UI Layer package and the application navigation logic.
/// This helps provide proper separation of concerns between the UI Layer of this package and in app where it is been used.
public protocol EventDetailRoutingLogic {
    /// WebView Navigation
    /// - Parameters:
    ///     - urlString:  link to be openedInWebView
    func navigateToWebView(urlString: String)

    /// ShareScreenNavigation
    /// - Parameters:
    ///     - shareData: EventDetail.ShareData to
    func navigateToShare(shareData: EventDetail.ShareData)

    /// Navigates to the Event Media screen
    /// - Parameter data: Event media data
    func navigateToMediaScreen(data: EventMediaDataModel, analyticsData: AnalyticsEvent)
}
