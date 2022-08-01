//
//  SegmentView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct SegmentView: View {
    struct ViewData {
        let title: String
        let colors: SegmentListViewBuilder.SegmentColors
        let fonts: SegmentListViewBuilder.SegmentFonts
        let segmentTitleLineHeight: CGFloat
        let isSelected: Bool
    }

    private let viewData: ViewData

    init(viewData: ViewData) {
        self.viewData = viewData
    }

    var body: some View {
        Text(viewData.title)
            .fontWithLineHeight(font: viewData.isSelected ? viewData.fonts.selectedFont : viewData.fonts.unselectedFont,
                                lineHeight: viewData.segmentTitleLineHeight,
                                verticalPadding: 9)
            .padding(.horizontal, 9)
            .foregroundColor(viewData.isSelected ? viewData.colors.selectedTextColor : viewData.colors.unselectedTextColor)
            .background(viewData.isSelected ? viewData.colors.selectedBackgroundColor : viewData.colors.unselectedBackgroundColor)
            .clipShape(Capsule())
    }
}
