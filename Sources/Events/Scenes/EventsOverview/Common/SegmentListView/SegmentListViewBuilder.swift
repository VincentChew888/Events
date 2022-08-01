//
//  SegmentListViewBuilder.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

final class SegmentListViewBuilder {
    // MARK: - View Data

    struct ViewData {
        let segmentsData: [SegmentData]
        let colors: SegmentColors
        let fonts: SegmentFonts
        let segmentTitleLineHeight: CGFloat
        let contentInsets: EdgeInsets
        let segmentSpacing: CGFloat
    }

    struct SegmentData {
        let title: String
        let startOfMonth: Date
    }

    // MARK: - Colors

    struct SegmentColors {
        let selectedBackgroundColor: Color
        let unselectedBackgroundColor: Color
        let selectedTextColor: Color
        let unselectedTextColor: Color
    }

    // MARK: - Fonts

    struct SegmentFonts {
        let selectedFont: UIFont
        let unselectedFont: UIFont
    }

    // MARK: - Default Values

    private enum Constants {
        static let selectedBackgroundColor = Theme.current.lightPurple.color
        static let unselectedBackgroundColor = Color.clear
        static let selectedTextColor = Theme.current.create.color
        static let unselectedTextColor = Color.white
        static let selectedFont: UIFont = Theme.current.bodyTwoBold.uiFont
        static let unselectedFont: UIFont = Theme.current.bodyTwoMedium.uiFont
        static let contentInsets = EdgeInsets(top: 16,
                                              leading: 16,
                                              bottom: 16,
                                              trailing: 16)
        static let segmentTitleLineHeight: CGFloat = Theme.current.bodyTwoBold.lineHeight
        static let segmentSpacing: CGFloat = 3
    }

    private(set) var segmentsData: [SegmentData] = []
    private(set) var colors: SegmentColors = SegmentColors(selectedBackgroundColor: Constants.selectedBackgroundColor,
                                                           unselectedBackgroundColor: Constants.unselectedBackgroundColor,
                                                           selectedTextColor: Constants.selectedTextColor,
                                                           unselectedTextColor: Constants.unselectedTextColor)
    private(set) var fonts: SegmentFonts = SegmentFonts(selectedFont: Constants.selectedFont,
                                                        unselectedFont: Constants.unselectedFont)
    private(set) var segmentTitleLineHeight: CGFloat = Constants.segmentTitleLineHeight
    private(set) var contentInsets: EdgeInsets = Constants.contentInsets
    private(set) var segmentSpacing: CGFloat = Constants.segmentSpacing

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setSegmentsData(segmentsData: [SegmentData]) -> SegmentListViewBuilder {
        self.segmentsData = segmentsData
        return self
    }

    public func setColors(colors: SegmentColors) -> SegmentListViewBuilder {
        self.colors = colors
        return self
    }

    public func setFonts(fonts: SegmentFonts) -> SegmentListViewBuilder {
        self.fonts = fonts
        return self
    }

    public func setSegmentTitleLineHeight(lineHeight: CGFloat) -> SegmentListViewBuilder {
        segmentTitleLineHeight = lineHeight
        return self
    }

    public func setContentInsets(insets: EdgeInsets) -> SegmentListViewBuilder {
        contentInsets = insets
        return self
    }

    public func setSegmentSpacing(segmentSpacing: CGFloat) -> SegmentListViewBuilder {
        self.segmentSpacing = segmentSpacing
        return self
    }

    public func build() -> ViewData {
        ViewData(segmentsData: segmentsData,
                 colors: colors,
                 fonts: fonts,
                 segmentTitleLineHeight: segmentTitleLineHeight,
                 contentInsets: contentInsets,
                 segmentSpacing: segmentSpacing)
    }
}
