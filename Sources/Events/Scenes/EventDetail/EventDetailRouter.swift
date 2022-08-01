//
//  EventDetailsRouter.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import CommonInteractions
import UIKit

struct EventDetailRouter {
    private var navigator: EventDetailRoutingLogic

    init(navigator: EventDetailRoutingLogic) {
        self.navigator = navigator
    }
}

extension EventDetailRouter: RoutingLogic {
    enum Destination {
        case openWebView(urlString: String)
        case mediaView(data: EventsMediaCell.MediaData, analyticsData: AnalyticsEvent)
        case openShare(shareData: EventDetail.ShareData)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case let .openWebView(urlString):
            navigator.navigateToWebView(urlString: urlString)
        case let .mediaView(data, analyticsData):
            navigator.navigateToMediaScreen(data: data, analyticsData: analyticsData)
        case let .openShare(shareData):
            navigator.navigateToShare(shareData: shareData)
        }
    }
}
