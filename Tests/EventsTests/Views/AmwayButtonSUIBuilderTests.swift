//
//  AmwayButtonSUIBuilderTests.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
@testable import Events
import SwiftUI
import XCTest

final class AmwayButtonSUIBuilderTests: XCTestCase {
    func testAmwayButtonBuilderDefaultState() throws {
        let buttonData: AmwayButtonSUIBuilder.AmwayButtonViewData = AmwayButtonSUIBuilder().build()

        XCTAssertEqual(buttonData.padding, 16.0)
        XCTAssertEqual(buttonData.lineHeight, Theme.current.bodyTwoBold.lineHeight)
        XCTAssertEqual(buttonData.foregroundColor, Theme.current.amwayWhite.color)
        XCTAssertEqual(buttonData.backroundColor, Theme.current.amwayBlack.color)
        XCTAssertEqual(buttonData.height, 36.0)
        XCTAssertEqual(buttonData.width, .infinity)
        XCTAssertEqual(buttonData.cornerRadius, 24)
        XCTAssertEqual(buttonData.font, Theme.current.bodyTwoBold.uiFont)
    }

    func testAmwayButtonBuilder() throws {
        let buttonData: AmwayButtonSUIBuilder.AmwayButtonViewData = AmwayButtonSUIBuilder()
            .setTitle("Register")
            .setPadding(9.0)
            .setFont(Theme.current.headline1.uiFont)
            .setLineHeight(Theme.current.headline1.lineHeight)
            .setForegroundColor(Theme.current.alertOrange.color)
            .setBackroundColor(Theme.current.alertOrange.color)
            .setHeight(20)
            .setWidth(30.0)
            .setCornerRadius(30)
            .build()

        XCTAssertEqual(buttonData.title, "Register")
        XCTAssertEqual(buttonData.padding, 9.0)
        XCTAssertEqual(buttonData.lineHeight, Theme.current.headline1.lineHeight)
        XCTAssertEqual(buttonData.foregroundColor, Theme.current.alertOrange.color)
        XCTAssertEqual(buttonData.backroundColor, Theme.current.alertOrange.color)
        XCTAssertEqual(buttonData.height, 20.0)
        XCTAssertEqual(buttonData.width, 30.0)
        XCTAssertEqual(buttonData.cornerRadius, 30)
        XCTAssertEqual(buttonData.font, Theme.current.headline1.uiFont)
    }
}
