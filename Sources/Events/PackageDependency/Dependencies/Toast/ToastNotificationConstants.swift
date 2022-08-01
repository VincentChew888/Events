//
//  ToastNotificationConstants.swift
//  Events
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

/// As we are considering the nav bar in-app using SwiftUIViewWithNavigation for some Events screen(Events Overview and Saved Events), the toast will not show on top of nav bar as it should according to the designs. In such cases, we need to display the toast in-app rather than in the package.
///
/// The constant values for the local notification to display toast.
/// notificationName - The notification will be posted from the package with this name. The application will observe for a notification with this name.
/// toastViewDataKey - The key name for the toastViewData that will be sent along with the notification. The application will use this key to extract the toastViewData.
/// eventsScreenTypeKey - The key name for the events screen type that will be sent along with the notification. The application will use this key to extract the events screen type..
public enum ToastNotificationConstants {
    public static let notificationName = "showToastForEvents"
    public static let toastViewDataKey = "toastViewData"
    public static let eventsScreenTypeKey = "eventsScreenTypeKey"
}

/// Enum to describe the Events screen type
public enum EventsScreenType: String {
    case overview
    case savedEvents
    case eventDetail
}
