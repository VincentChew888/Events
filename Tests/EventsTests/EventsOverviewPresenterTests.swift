//
//  EventsOverviewPresenterTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//
@testable import Events
import XCTest

class EventsOverviewPresenterTests: XCTestCase {
    var presenter: EventsOverviewPresenter!
    var interactor: EventsInteractorMock!

    override func setUp() {
        super.setUp()

        interactor = EventsInteractorMock()
        presenter = EventsOverviewPresenter(interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()

        presenter = nil
    }

    func testSegmentsData() {
        let segmentsData = presenter.segmentsData()
        XCTAssertEqual(segmentsData.count,
                       EventsOverviewPresenter.Constants.numberOfYears * EventsOverviewPresenter.Constants.lastMonthIndex)
        XCTAssertEqual(segmentsData.first?.title, Date().getMonth(byAdding: 0)?.monthString())
    }

    func testSegmentsDataNextYearFirstMonthScenario() {
        let segmentsData = presenter.segmentsData()
        let nextYearDate = Calendar.current.date(byAdding: .year, value: 1, to: Date().isoDate() ?? Date()) ?? Date()
        let nextYearNumber = nextYearDate.defaultLocalizedDateStringWithISOFormat(using: "yyyy")
        if Date().getMonth() != 1 {
            XCTAssertFalse(segmentsData.filter { $0.title == "\(nextYearNumber) Jan" }.isEmpty)
        }
    }

    func testSaveEventSuccess() {
        interactor.success = true
        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true)
        presenter.saveEvent(request: request)

        eventually {
            let isSuccess: Bool
            switch self.presenter.state {
            case .success:
                isSuccess = true
            default:
                isSuccess = false
            }
            XCTAssertTrue(isSuccess, "Expected to be a success but got a failure with \(self.presenter.state)")
        }
    }

    func testSaveEventFailure() {
        interactor.success = false
        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true)
        presenter.saveEvent(request: request)
        eventually {
            let isFailure: Bool
            switch self.presenter.state {
            case .failure(.connectivity):
                isFailure = true
            default:
                isFailure = false
            }
            XCTAssertTrue(isFailure, "Expected to be a failure but got a success with \(self.presenter.state)")
        }
    }
}
