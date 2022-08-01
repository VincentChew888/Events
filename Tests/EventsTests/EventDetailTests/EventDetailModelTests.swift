//
//  EventDetailModelTests.swift
//
//
//  Created by Amway on 23/06/22.
//

import Events
import XCTest

class EventDetailModelTests: XCTestCase {
    func testVirtualEventLocation() {
        let eventFields = EventDetailFeildsMock.mockData()
        let eventDetail = EventDetail.virtualEventMock()
        let shareData = EventDetail.ShareData(eventDetail: eventDetail, eventFields: eventFields)
        let expectedLocation = eventDetail.location.replacingOccurrences(of: "\n", with: ",")
        XCTAssertEqual(expectedLocation, shareData.locationOrAddress)
    }

    func testNonVirtualEventLocation() {
        let eventFields = EventDetailFeildsMock.mockData()
        let eventDetail = EventDetail.nonVirtualEventMock()
        let shareData = EventDetail.ShareData(eventDetail: eventDetail, eventFields: eventFields)
        let expectedLocation = eventDetail.address.replacingOccurrences(of: "\n", with: ",")
        XCTAssertEqual(expectedLocation, shareData.locationOrAddress)
    }

    func testRegistrationLink() {
        let eventFields = EventDetailFeildsMock.mockData()
        let eventDetail = EventDetail.registrationLinkEventMock()
        let shareData = EventDetail.ShareData(eventDetail: eventDetail, eventFields: eventFields)
        let expectedLinkText = "\(eventFields.registrationLinkShareText)\(eventDetail.registrationLink)"
        XCTAssertEqual(expectedLinkText, shareData.linkInfo)
    }

    func testPublicDetailsLink() {
        let eventFields = EventDetailFeildsMock.mockData()
        let eventDetail = EventDetail.publicDetailsLinkEventMock()
        let shareData = EventDetail.ShareData(eventDetail: eventDetail, eventFields: eventFields)
        let expectedLinkText = "\(eventFields.publicDetailsLinkShareText)\(eventDetail.publicDetailsLink)"
        XCTAssertEqual(expectedLinkText, shareData.linkInfo)
    }

    func testBothRegistrationAndPublicDetailsLink() {
        let eventFields = EventDetailFeildsMock.mockData()
        let eventDetail = EventDetail.registrationAndPublicDetailsLinkEventMock()
        let shareData = EventDetail.ShareData(eventDetail: eventDetail, eventFields: eventFields)
        let expectedLinkText = "\(eventFields.registrationLinkShareText)\(eventDetail.registrationLink)"
        XCTAssertEqual(expectedLinkText, shareData.linkInfo)
    }
}
