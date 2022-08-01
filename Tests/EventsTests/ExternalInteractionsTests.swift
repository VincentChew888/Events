//
//  ExternalInteractionsTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

@testable import Events
import XCTest

class ExternalInteractionsTests: XCTestCase {
    var sut: ExternalInteractionsRouter?

    override func setUp() {
        super.setUp()
        sut = ExternalInteractionsRouter()
    }

    override func tearDown() async throws {
        sut = nil
    }

    func testOpenURL() {
        guard let sut = sut else {
            return
        }
        sut.isSuccess = false
        XCTAssertFalse(sut.isUrlOpenedCorrectly)
        sut.isSuccess = true
        sut.openUrl(urlString: "testURl")
        XCTAssertTrue(sut.isUrlOpenedCorrectly)
    }

    func testOpenSettings() {
        guard let sut = sut else {
            return
        }
        sut.isSuccess = false
        XCTAssertFalse(sut.isSettingsOpenedCorrectly)
        sut.isSuccess = true
        sut.openSettings()
        XCTAssertTrue(sut.isSettingsOpenedCorrectly)
    }
}
