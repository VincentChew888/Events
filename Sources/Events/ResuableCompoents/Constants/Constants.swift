//
//  Constants.swift
//  Amway
//
//  Copyright © Amway. All rights reserved.
//

import Foundation

enum Storyboard {
    static let internetError = "InternetError"
    static let connectivityError = "ConnectivityError"
}

enum AutomationControl: String, AccessibilityIdentifierProvider {
    case activityIndicator
}

enum CommonConstants {
    static let noData = "--"
    static let noDataCS = "-"
}

enum CommonLayerConstants {
    static let bezierPath = "bezierPath"
}
