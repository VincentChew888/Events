//
//  XCTestCase+Extension.swift
//  EventsTests
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    /*
     This changes was causing to fail more than 60 UT cases, commenting this until find valid solution.
     @available(iOS, deprecated: 14.0, message: "This method will be removed in the near future.")
      func eventually(timeout _: TimeInterval = 0.01, callback: @escaping () -> Void) {
          callback()
      }
     */
    /// eventually performs closure after timeout passes.
    /// - Parameters:
    ///   - timeout: time in seconds to wait before executing the callback closure.
    ///   - callback: a closure to perform when timeout seconds has passed.
    func eventually(timeout: TimeInterval = 0.01, callback: @escaping () -> Void) {
        let expectation = self.expectation(description: "")
        expectation.fulfillAfter(timeout)
        waitForExpectations(timeout: 60) { _ in
            callback()
        }
    }
}
