//
//  SavedEventsModelTests.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

@testable import Events
import XCTest

class SavedEventsModelTests: XCTestCase {
    func testGetEventInfo() {
        let info1 = SavedEvent.getEventInfo(startTime: "2022-05-09T04:00:00.000Z", location: "Taiwan")
        let date = "2022-05-09T04:00:00.000Z".defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.monthDateAndHours)
        let time = "2022-05-09T04:00:00.000Z".defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.hourAndMin)
        XCTAssertEqual(info1, "\(date) · \(time) · Taiwan")

        let info2 = SavedEvent.getEventInfo(startTime: nil, location: "Taiwan")
        XCTAssertEqual(info2, "Taiwan")
    }
}
