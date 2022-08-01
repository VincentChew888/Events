//
//  XCTestExpectation+Extension.swift
//  EventsTests
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation
import XCTest

extension XCTestExpectation {
    /// - Parameter time: time after which fulfill will be called.
    func fulfillAfter(_ time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fulfill()
        }
    }
}
