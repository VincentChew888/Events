//
//  ExternalInteractionsRouter.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Events
import Foundation

final class ExternalInteractionsRouter: ExternalApplicationLogic {
    var isSuccess = false
    var isUrlOpenedCorrectly = false
    var isSettingsOpenedCorrectly = false

    func openUrl(urlString _: String) {
        isUrlOpenedCorrectly = isSuccess ? true : false
    }

    func openSettings() {
        isSettingsOpenedCorrectly = isSuccess ? true : false
    }

    init() {}
}
