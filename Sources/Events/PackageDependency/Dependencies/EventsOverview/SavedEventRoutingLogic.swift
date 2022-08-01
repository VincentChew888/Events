//
//  SavedEventRoutingLogic.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

/// The events router facilitate communication between the routing/Navigation from the this UI Layer package and the application navigation logic.
/// This helps provide proper separation of concerns between the UI Layer of this package and in app where it is been used.
public protocol SavedEventRoutingLogic {
    /// DetailsScreenNavigation
    /// - Parameters:
    ///     - eventId:  String
    func navigateToDetailsScreen(eventId: String)
}
