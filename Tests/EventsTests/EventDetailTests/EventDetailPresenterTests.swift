//
//  EventDetailPresenterTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//
import Combine
@testable import Events
import XCTest

class EventDetailPresenterTests: XCTestCase {
    var presenter: EventDetailPresenter!
    var interactor: EventDetailInteractorMock!
    var navigator: MockNavigator!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        navigator = MockNavigator()
        let router = EventDetailRouter(navigator: navigator)
        interactor = EventDetailInteractorMock(provider: EventDetailDataProviderMock())
        presenter = EventDetailPresenter(interactor: interactor)
        presenter.setRouter(router)
    }

    override func tearDown() {
        super.tearDown()

        presenter = nil
        interactor = nil
    }

    func testFetchEventDetail() {
        interactor.success = true

        presenter.fetchEventDetail(type: .initialLoad)
        eventually {
            XCTAssertNotNil(self.presenter.state)
        }
    }

    func testVirtualEventDetailWithMedia() {
        interactor.success = true
        interactor.isVirtualMediaEvent = true

        presenter.fetchEventDetail(type: .initialLoad)
        eventually {
            XCTAssertNotNil(self.presenter.state)
        }
    }

    func testFetchEventDetailFailure() {
        interactor.success = false
        presenter.fetchEventDetail(type: .initialLoad)
        eventually {
            XCTAssertNotNil(self.presenter.state)
        }

        interactor.isInternetError = true
        presenter.fetchEventDetail(type: .initialLoad)
        eventually {
            XCTAssertNotNil(self.presenter.state)
        }
    }

    func testFetchEventDetailResponse() {
        interactor.success = true

        presenter.fetchEventDetail(type: .initialLoad)
        XCTAssertNotNil(presenter.state)
    }

    func testNavigationToWebview() {
        XCTAssertFalse(navigator.isNavigatedSuccessfullyToWebview)
        presenter.openUrl(urlString: "testUrl")
        XCTAssertTrue(navigator.isNavigatedSuccessfullyToWebview)
    }

    func testNavigationToShare() {
        presenter.openShare(shareData: EventDetail.ShareData(aboEvent: true,
                                                             title: "",
                                                             description: "",
                                                             linkInfo: "",
                                                             heroImageUrl: "",
                                                             startDateTime: Date(),
                                                             endDateTime: Date(),
                                                             locationOrAddress: "",
                                                             shareText: ""))
        XCTAssertTrue(navigator.shareNavigationSuccess)
    }

    func testEventId() {
        presenter.setEventId("123")
        _ = interactor.fetchEventDetail(request: EventDetail.Model.Request(eventId: "123"),
                                        type: .initialLoad)
        XCTAssertEqual(interactor.eventId, "123")
    }

    func testFetchTitle() {
        interactor.success = true
        let title = presenter.fetchTitle()
        XCTAssertEqual(title, "test EventDetailTitle")
    }

    func testSaveEventSuccess() {
        interactor.success = true
        presenter.saveEvent(isSaved: true)

        eventually {
            XCTAssertFalse(self.presenter.showSaveEventFailureToast)
        }
    }

    func testSaveEventFailure() {
        interactor.success = false
        presenter.saveEvent(isSaved: true)
        eventually {
            XCTAssertTrue(self.presenter.showSaveEventFailureToast)
            XCTAssertNotNil(self.presenter.saveEventFailureToastData)
        }
    }

    func testMediaValidationErrorAlertInfo() {
        interactor.success = true

        let videoInfo = presenter.mediaValidationAlertInfo(mediaType: .video)
        XCTAssertEqual(videoInfo.title, "videoErrorTitle")
        XCTAssertEqual(videoInfo.message, "videoErrorMessage")

        let imageInfo = presenter.mediaValidationAlertInfo(mediaType: .image)
        XCTAssertEqual(imageInfo.title, "imageErrorTitle")
        XCTAssertEqual(imageInfo.message, "imageErrorMessage")

        let info = presenter.mediaValidationAlertInfo(mediaType: .pdf)
        XCTAssertEqual(info.title, "pdfErrorTitle")
        XCTAssertEqual(info.message, "pdfErrorMessage")

        interactor.success = false

        let videoInfoFailure = presenter.mediaValidationAlertInfo(mediaType: .video)
        XCTAssertEqual(videoInfoFailure.title, CommonConstants.noDataCS)
        XCTAssertEqual(videoInfoFailure.message, CommonConstants.noDataCS)

        let imageInfoFailure = presenter.mediaValidationAlertInfo(mediaType: .image)
        XCTAssertEqual(imageInfoFailure.title, CommonConstants.noDataCS)
        XCTAssertEqual(imageInfoFailure.message, CommonConstants.noDataCS)

        let infoFailure = presenter.mediaValidationAlertInfo(mediaType: .pdf)
        XCTAssertEqual(infoFailure.title, CommonConstants.noDataCS)
        XCTAssertEqual(infoFailure.message, CommonConstants.noDataCS)
    }
}
