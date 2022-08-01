//
//  EventsOverviewInteractorTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import XCTest

class EventsOverviewInteractorTests: XCTestCase {
    var interactor: EventsOverviewInteractor!
    var provider: EventsProviderMock!
    var saveEventProvider: SaveEventProviderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        cancellables = []
        provider = EventsProviderMock()
        saveEventProvider = SaveEventProviderMock()
        PackageDependency.setSaveEventProvider(provider: saveEventProvider)
        interactor = EventsOverviewInteractor(provider: provider)
    }

    override func tearDown() {
        super.tearDown()

        provider = nil
        interactor = nil
    }

    func testFetchEventsInitialLoad() {
        var error: Error?
        var response: EventsOverview.Model.Response?
        let expectation = self.expectation(description: "EventsFetch")

        interactor.fetchEvents(request: EventsOverview.Model.Request(isSavedEvents: false), type: .initialLoad).sink { completion in
            switch completion {
            case .finished: break
            case let .failure(encounteredError):
                error = encounteredError
            }
            expectation.fulfill()
        } receiveValue: { value in
            response = value
        }.store(in: &cancellables)

        waitForExpectations(timeout: 1)

        XCTAssertNotNil(error)
        XCTAssertNil(response)
    }

    func testFetchEventsFromPreview() {
        var error: Error?
        var response: EventsOverview.Model.Response?
        let expectation = self.expectation(description: "EventsFetch")
        provider.success = true

        interactor.fetchEvents(request: EventsOverview.Model.Request(isSavedEvents: false), type: .preview).sink { completion in
            switch completion {
            case .finished: break
            case let .failure(encounteredError):
                error = encounteredError
            }
            expectation.fulfill()
        } receiveValue: { value in
            response = value
        }.store(in: &cancellables)

        waitForExpectations(timeout: 1)

        XCTAssertNil(error)
        XCTAssertNotNil(response)
    }

    func testSaveEventSuccess() {
        var error: Error?
        var response: EventsOverview.Model.Response?
        let expectation = self.expectation(description: "SaveEventSuccess")
        provider.success = true
        saveEventProvider.success = true

        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true)
        interactor.saveEvent(request: request)
            .sink { completion in
                switch completion {
                case .finished: break
                case let .failure(encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                response = value
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)

        XCTAssertNil(error)
        XCTAssertNotNil(response)
    }

    func testSaveEventFailure() {
        var error: Error?
        var response: EventsOverview.Model.Response?
        let expectation = self.expectation(description: "SaveEventFailure")
        provider.success = false
        saveEventProvider.success = false

        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true)
        interactor.saveEvent(request: request)
            .sink { completion in
                switch completion {
                case .finished: break
                case let .failure(encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                response = value
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)

        XCTAssertNotNil(error)
        XCTAssertNil(response)
    }
}
