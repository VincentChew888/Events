//
//  MockNavigator.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import CommonInteractions
import Events

final class MockNavigator: EventsRoutingLogic, EventDetailRoutingLogic {
    var isNavigatedSuccessfullyToWebview = false
    var shareNavigationSuccess = false

    func navigateToDetailsScreen(eventId _: String) {}

    func navigateToWebView(urlString _: String) {
        isNavigatedSuccessfullyToWebview = true
    }

    func navigateToMediaScreen(data _: EventMediaDataModel, analyticsData _: AnalyticsEvent) {}

    func navigateToShare(shareData _: EventDetail.ShareData) {
        shareNavigationSuccess = true
    }
}
