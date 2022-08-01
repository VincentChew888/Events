//  CarouselViewSUIBuilder.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
@testable import Events
import SwiftUI
import XCTest

final class CarouselViewSUIBuilderTests: XCTestCase {
    func testCarouselViewSUIBuilderDefaultState() throws {
        let carouselData: CarouselViewSUIBuilder.CarouselViewSUIData = CarouselViewSUIBuilder().build()

        XCTAssertEqual(carouselData.spacing, 8.0)
        XCTAssertEqual(carouselData.cellPadding, 16.0)
        XCTAssertEqual(carouselData.singleItemCellHeight, 273)
        XCTAssertEqual(carouselData.multipleItemCellWidth, 284)
        XCTAssertEqual(carouselData.multipleItemCellHeight, 240)
    }

    func testCarouselViewSUIBuilder() throws {
        let carouselData: CarouselViewSUIBuilder.CarouselViewSUIData = CarouselViewSUIBuilder()
            .setSingleItemCellHeight(300)
            .setMultipleItemCellWidth(300)
            .setMultipleItemCellHeight(300)
            .setSpacing(300)
            .setCellPadding(300)
            .build()

        XCTAssertEqual(carouselData.spacing, 300.0)
        XCTAssertEqual(carouselData.cellPadding, 300.0)
        XCTAssertEqual(carouselData.singleItemCellHeight, 300)
        XCTAssertEqual(carouselData.multipleItemCellWidth, 300)
        XCTAssertEqual(carouselData.multipleItemCellHeight, 300.0)
    }
}
