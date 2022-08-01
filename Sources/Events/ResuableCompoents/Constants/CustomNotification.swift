//
//  CustomNotification.swift
//  Events
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

enum CustomNotification: String {
    case eventsOverviewSegmentChange

    var name: Notification.Name { NSNotification.Name(rawValue: rawValue) }

    enum UserInfoKeys {
        static let segmentChangeData = "segmentChangeData"
    }
}
