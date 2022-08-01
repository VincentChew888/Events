//
//  EventDetailInteractorTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//
import Combine
@testable import Events
import XCTest

class EventDetailInteractorTests: XCTestCase {
    var interactor: EventDetailInteractor!
    var provider: EventDetailDataProviderMock!
    var saveEventProvider: SaveEventProviderMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
        provider = EventDetailDataProviderMock()
        saveEventProvider = SaveEventProviderMock()
        PackageDependency.setSaveEventProvider(provider: saveEventProvider)
        interactor = EventDetailInteractor(provider: provider,
                                           calendarEventStoreLogic: CalendarEventStoreProviderMock())
    }

    override func tearDown() {
        super.tearDown()

        interactor = nil
    }

    func testFetchEventsDetailsInitialLoad() {
        var error: Error?
        var response: EventDetail.Model.Response?

        provider.isSuccess = true

        interactor.fetchEventDetail(request: EventDetail.Model.Request(eventId: "123"), type: .initialLoad).sink { completion in
            switch completion {
            case .finished: break
            case let .failure(encounteredError):
                error = encounteredError
                XCTAssertNil(error)
            }
        } receiveValue: { value in
            response = value
            XCTAssertNotNil(response)
        }.store(in: &cancellables)
    }

    func testFetchEventDetailsFailure() {
        var error: Error?
        var response: EventDetail.Model.Response?
        provider.isSuccess = false

        interactor.fetchEventDetail(request: EventDetail.Model.Request(eventId: "123"), type: .initialLoad).sink { completion in
            switch completion {
            case .finished: break
            case let .failure(encounteredError):
                error = encounteredError
                XCTAssertNotNil(error)
            }
        } receiveValue: { value in
            response = value
            XCTAssertNil(response)
        }.store(in: &cancellables)
    }

    func testFetchEventDetailFields() {
        provider.isSuccess = true
        XCTAssertNotNil(interactor.fetchEventDetailFields())
        provider.isSuccess = false
        XCTAssertNil(interactor.fetchEventDetailFields())
    }

    func testSaveEventSuccess() {
        var error: Error?
        var response: EventDetail.Model.Response?
        let expectation = self.expectation(description: "SaveEventSuccess")
        provider.isSuccess = true
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
        var response: EventDetail.Model.Response?
        let expectation = self.expectation(description: "SaveEventFailure")
        provider.isSuccess = false
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

struct CalendarEventStoreProviderMock: CalendarEventStoreProviderLogic {
    func save(event _: CalendarEventData, callback _: ((Bool, Error?) -> Void)?) {}

    func getAuthorisationStatus(callback _: @escaping (Bool) -> Void) {}
}
