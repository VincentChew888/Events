//
//  EventOverviewModelTests.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

@testable import Events
import XCTest

class EventOverviewModelTests: XCTestCase {
    func testEventsData() {
        let mockData = EventsOverview.mockData()
        let eventSections = EventsOverview.sections(using: mockData, staticData: EventsOverViewFieldsMock.mockData())
        let month = Calendar.current.component(.month, from: Date())
        let totalMonths = EventsOverview.Constants.lastMonthIndex * EventsOverview.Constants.numberOfYears
        XCTAssertEqual(eventSections.first?.month, 6) // As per mock data
        // Mock data have 3 entry with 2 sections so total section should be 13
        XCTAssertEqual(eventSections.last?.month,
                       (month + totalMonths) - 1)
    }

    func testSectionKey() {
        let staticData = EventsOverViewFieldsMock.mockData()
        let eventSection1 = EventsOverview.sectionKey(eventStart: "",
                                                      staticData: staticData)
        XCTAssertEqual(eventSection1, staticData.emptyMonthDescription)

        let eventSection2 = EventsOverview.sectionKey(eventStart: "2022-05-09T04:00:00.000Z",
                                                      staticData: staticData)
        XCTAssertEqual(eventSection2, "Monday, May 9") // Date format: EEEE, MMMM d

        let eventSection3 = EventsOverview.sectionKey(month: 1,
                                                      eventStart: "",
                                                      staticData: staticData)
        XCTAssertEqual(eventSection3,
                       staticData.emptyMonthDescription.replacingOccurrences(of: "{{Month}}",
                                                                             with: "January"))
    }

    func testGetEventDescription() {
        let startTime = "2022-05-09T04:00:00.000Z"
        let description1 = EventsOverview.getEventDescription(startTime: startTime,
                                                              location: "Taiwan")
        let time = startTime.defaultLocalizedDateStringWithLocaleWithISOFormat(using: DateFormat.hourAndMin)
        XCTAssertEqual(description1, "\(time) • Taiwan")

        let description2 = EventsOverview.getEventDescription(startTime: nil,
                                                              location: "Taiwan")
        XCTAssertEqual(description2, "Taiwan")
    }

    func testGetDuration() {
        let duration1 = EventsOverview.getDuration(startTime: "2022-05-09T04:00:00.000Z",
                                                   endTime: "2022-05-09T06:00:00.000Z")
        XCTAssertEqual(duration1, "2:00")

        let duration2 = EventsOverview.getDuration(startTime: "2022-05-09T04:00:00.000Z",
                                                   endTime: "2022-05-09T10:30:00.000Z")
        XCTAssertEqual(duration2, "6:30")

        let duration3 = EventsOverview.getDuration(startTime: "",
                                                   endTime: "2022-05-09T06:00:00.000Z")
        XCTAssertEqual(duration3, "")
    }
}
