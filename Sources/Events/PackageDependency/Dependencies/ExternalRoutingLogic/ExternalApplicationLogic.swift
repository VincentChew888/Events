//
//  MapsRouterLogic.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

/// The ExternalInteractionLogic  facilitates opening for various applications of iPhone from events package.
public protocol ExternalApplicationLogic {
    /// DetailsScreenNavigation
    /// - Parameters:
    ///     - urlString:  string contains http url for application to be opened.
    func openUrl(urlString: String)

    /// abstraction to open settings app of iPhone from eventspackage
    func openSettings()
}
