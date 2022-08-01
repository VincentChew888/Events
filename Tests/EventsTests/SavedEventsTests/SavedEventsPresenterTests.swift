//
//  SavedEventsPresenterTests.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import XCTest

class SavedEventsPresenterTests: XCTestCase {
    var presenter: SavedEventsPresenter!
    var interactor: SavedEventsInteractorMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        interactor = SavedEventsInteractorMock()
        presenter = SavedEventsPresenter(interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()

        presenter = nil
        interactor = nil
    }

    func testFetchSavedEvents() {
        interactor.success = true

        presenter.fetchSavedEvents(type: .initialLoad)
        XCTAssertNotNil(presenter.state)
    }

    func testFetchSavedEventsFailure() {
        interactor.success = false

        presenter.fetchSavedEvents(type: .initialLoad)
        XCTAssertNotNil(presenter.state)
    }

    func testFetchTitle() {
        interactor.success = true
        let title = presenter.fetchTitle()
        XCTAssertEqual(title, "")
    }

    func testSaveEventSuccess() {
        interactor.success = true
        let request = SaveEventRequest(eventId: EventsOverview.mockData().first?.eventId ?? "",
                                       isSaved: true,
                                       filterOnlySavedEvents: true)
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
                                       isSaved: true,
                                       filterOnlySavedEvents: true)
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
