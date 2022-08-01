//
//  ToastViewInteractorTests.swift
//
//  Created by Banu Harshavardhan on 29/06/22.
//

import Combine
@testable import Events
import XCTest

class ToastViewInteractorTests: XCTestCase {
    var provider: ErrorDataProviderLogic!
    var interactor: ToastViewInteractor!
    private var cancellables: Set<AnyCancellable>!
    override func setUp() {
        super.setUp()
        cancellables = []
        provider = ErrorDataProviderMock()
        interactor = ToastViewInteractor(provider: provider)
    }

    override func tearDown() {
        super.tearDown()
        provider = nil
        interactor = nil
    }

    func testFetchToastError() {
        var error: Error?
        var staticData: ToastError.StaticData?
        let expectation = self.expectation(description: "ToastError")

        interactor.fetchToastError().sink { completion in
            switch completion {
            case .finished: break
            case let .failure(encounteredError):
                error = encounteredError
            }
            expectation.fulfill()
        } receiveValue: { value in
            staticData = value
        }.store(in: &cancellables)

        waitForExpectations(timeout: 1)

        XCTAssertNil(error)
        XCTAssertNotNil(staticData)
    }
}
