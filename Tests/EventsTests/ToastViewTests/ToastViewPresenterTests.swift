//
//  ToastViewPresenterTests.swift
//
//
//  Created by Banu Harshavardhan on 29/06/22.
//

@testable import Events
import XCTest

class ToastViewPresenterTests: XCTestCase {
    var interactor: ToastViewInteractorMock!
    var presenter: ToastViewPresenter!

    override func setUp() {
        super.setUp()

        interactor = ToastViewInteractorMock()
        presenter = ToastViewPresenter(interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()

        interactor = nil
        presenter = nil
    }

    func testFetchToastError() {
        presenter.fetchToastErrorData()
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
}
