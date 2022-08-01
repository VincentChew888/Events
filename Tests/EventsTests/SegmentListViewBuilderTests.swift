//
//  SegmentListViewBuilderTests.swift
//  EventsTests
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
@testable import Events
import SwiftUI
import XCTest

final class SegmentListViewBuilderTests: XCTestCase {
    func testSegmentListViewBuilderDefaultState() throws {
        let defaultSegmentsData: [SegmentListViewBuilder.SegmentData] = []
        let defaultColors = SegmentListViewBuilder
            .SegmentColors(selectedBackgroundColor: Theme.current.lightPurple.color,
                           unselectedBackgroundColor: Color.clear,
                           selectedTextColor: Theme.current.create.color,
                           unselectedTextColor: Color.white)
        let defaultFonts = SegmentListViewBuilder
            .SegmentFonts(selectedFont: Theme.current.bodyTwoBold.uiFont,
                          unselectedFont: Theme.current.bodyTwoMedium.uiFont)
        let defaultSegmentTitleLineHeight: CGFloat = 18
        let defaultContentInsets: EdgeInsets = EdgeInsets(top: 16,
                                                          leading: 16,
                                                          bottom: 16,
                                                          trailing: 16)
        let defaultSegmentSpacing: CGFloat = 3

        let segmentListData = SegmentListViewBuilder().build()

        XCTAssertEqual(defaultSegmentsData.count, segmentListData.segmentsData.count)
        XCTAssertEqual(defaultColors.selectedTextColor, segmentListData.colors.selectedTextColor)
        XCTAssertEqual(defaultColors.unselectedTextColor, segmentListData.colors.unselectedTextColor)
        XCTAssertEqual(defaultColors.selectedBackgroundColor, segmentListData.colors.selectedBackgroundColor)
        XCTAssertEqual(defaultColors.unselectedBackgroundColor, segmentListData.colors.unselectedBackgroundColor)
        XCTAssertEqual(defaultFonts.selectedFont, segmentListData.fonts.selectedFont)
        XCTAssertEqual(defaultFonts.unselectedFont, segmentListData.fonts.unselectedFont)
        XCTAssertEqual(defaultSegmentTitleLineHeight, segmentListData.segmentTitleLineHeight)
        XCTAssertEqual(defaultContentInsets, segmentListData.contentInsets)
        XCTAssertEqual(defaultSegmentSpacing, segmentListData.segmentSpacing)
    }

    func testSegmentListViewBuilder() throws {
        let segmentsData: [SegmentListViewBuilder.SegmentData] = [SegmentListViewBuilder.SegmentData(title: "March",
                                                                                                     startOfMonth: Date()),
                                                                  SegmentListViewBuilder.SegmentData(title: "April",
                                                                                                     startOfMonth: Date())]
        let colors = SegmentListViewBuilder
            .SegmentColors(selectedBackgroundColor: Theme.current.amwayBlack.color,
                           unselectedBackgroundColor: Theme.current.backgroundGray.color,
                           selectedTextColor: Theme.current.gray1.color,
                           unselectedTextColor: Theme.current.gray2.color)
        let fonts = SegmentListViewBuilder
            .SegmentFonts(selectedFont: Theme.current.bodyOneRegular.uiFont,
                          unselectedFont: Theme.current.bodyTwoRegular.uiFont)
        let segmentTitleLineHeight: CGFloat = Theme.current.bodyOneRegular.lineHeight
        let contentInsets: EdgeInsets = EdgeInsets(top: 10,
                                                   leading: 10,
                                                   bottom: 10,
                                                   trailing: 10)
        let segmentSpacing: CGFloat = 10

        let segmentListData = SegmentListViewBuilder()
            .setSegmentsData(segmentsData: segmentsData)
            .setColors(colors: colors)
            .setFonts(fonts: fonts)
            .setSegmentTitleLineHeight(lineHeight: segmentTitleLineHeight)
            .setContentInsets(insets: contentInsets)
            .setSegmentSpacing(segmentSpacing: segmentSpacing)
            .build()

        XCTAssertEqual(segmentsData.count, segmentListData.segmentsData.count)
        XCTAssertEqual(segmentsData.first?.title, segmentListData.segmentsData.first?.title)
        XCTAssertEqual(colors.selectedTextColor, segmentListData.colors.selectedTextColor)
        XCTAssertEqual(colors.unselectedTextColor, segmentListData.colors.unselectedTextColor)
        XCTAssertEqual(colors.selectedBackgroundColor, segmentListData.colors.selectedBackgroundColor)
        XCTAssertEqual(colors.unselectedBackgroundColor, segmentListData.colors.unselectedBackgroundColor)
        XCTAssertEqual(fonts.selectedFont, segmentListData.fonts.selectedFont)
        XCTAssertEqual(fonts.unselectedFont, segmentListData.fonts.unselectedFont)
        XCTAssertEqual(segmentTitleLineHeight, segmentListData.segmentTitleLineHeight)
        XCTAssertEqual(contentInsets, segmentListData.contentInsets)
        XCTAssertEqual(segmentSpacing, segmentListData.segmentSpacing)
    }
}
