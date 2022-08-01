//
//  SavedEventsInteractorTests.swift
//  AmwayTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Combine
@testable import Events
import XCTest

class SavedEventsInteractorTests: XCTestCase {
    var interactor: SavedEventsInteractor!
    var provider: EventsProviderMock!
    var saveEventProvider: SaveEventProviderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        cancellables = []
        provider = EventsProviderMock()
        saveEventProvider = SaveEventProviderMock()
        PackageDependency.setSaveEventProvider(provider: saveEventProvider)
        interactor = SavedEventsInteractor(provider: provider)
    }

    override func tearDown() {
        super.tearDown()

        provider = nil
        interactor = nil
    }

    func testFetchEventsInitialLoad() {
        var error: Error?
        var response: SavedEvent.Model.Response?
        let expectation = self.expectation(description: "EventsFetch")

        interactor.fetchSavedEvents(request: SavedEvent.Model.Request(), type: .initialLoad).sink { completion in
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
        var response: SavedEvent.Model.Response?
        let expectation = self.expectation(description: "EventsFetch")
        provider.success = true

        interactor.fetchSavedEvents(request: SavedEvent.Model.Request(), type: .preview).sink { completion in
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

    func testFetchSavedEventFieldsFailure() {
        let fields = interactor.fetchSavedEventsFields()
        XCTAssertNil(fields)
    }

    func testFetchSavedEventFields() {
        provider.success = true
        let fields = interactor.fetchSavedEventsFields()
        XCTAssertNotNil(fields)
    }

    func testSaveEventSuccess() {
        var error: Error?
        var response: SavedEvent.Model.Response?
        let expectation = self.expectation(description: "SaveEventSuccess")
        saveEventProvider.success = true
        provider.success = true

        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true,
                                       filterOnlySavedEvents: true)
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
        var response: SavedEvent.Model.Response?
        let expectation = self.expectation(description: "SaveEventFailure")
        saveEventProvider.success = false
        provider.success = false

        let request = SaveEventRequest(eventId: "1",
                                       isSaved: true,
                                       filterOnlySavedEvents: true)
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
