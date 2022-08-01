//
//  CarouselViewSUI.swift
//  EventsMedia
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct CarouselViewSUI<Content: View, Data>: View {
    // MARK: - Properties

    let viewData: CarouselViewSUIBuilder.CarouselViewSUIData
    let items: [Data]
    let onTap: (Data) -> Void
    let viewBuilder: (Data) -> Content

    private func cell(index: Int) -> some View {
        ZStack {
            if index < items.count {
                self.viewBuilder(items[index])
            }
        }
    }

    private var isSingleItem: Bool {
        items.count == 1
    }

    private var cellWidth: CGFloat {
        let multipleItemsCellWidth = viewData.multipleItemCellWidth + 2 * viewData.cellPadding + viewData.spacing
        let singleItemCellWidth = UIScreen.main.bounds.width - 2 * viewData.cellPadding
        return isSingleItem ? singleItemCellWidth : multipleItemsCellWidth
    }

    private var cellHeight: CGFloat {
        isSingleItem ? viewData.singleItemCellHeight : viewData.multipleItemCellHeight
    }

    // MARK: - View

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: viewData.spacing) {
                ForEach(0 ..< items.count, id: \.self) { index in

                    // Padding should vary based on single cell or multiple cells.
                    // Padding Offsets to construct 16.0  leading and trailing.
                    // & To have spacing of 8.0 between two items
                    let isLast = index == items.count - 1
                    let isFirst = index == 0
                    let firstItemLeadingPaddingOffest = isFirst ? viewData.cellPadding : 0
                    let lastItemLeadingPaddingOffset = isLast ? 0 : firstItemLeadingPaddingOffest
                    let lastItemTrailingPaddingOffset = isLast ? viewData.cellPadding : 0
                    let leading = isSingleItem ? viewData.cellPadding : lastItemLeadingPaddingOffset
                    let trailing = isSingleItem ? viewData.cellPadding : lastItemTrailingPaddingOffset

                    let padding = EdgeInsets(top: 0,
                                             leading: leading,
                                             bottom: 0,
                                             trailing: trailing)

                    cell(index: index)
                        .frame(width: cellWidth, height: cellHeight)
                        .padding(padding)
                        .onTapGesture {
                            onTap(items[index])
                        }
                }
            }
        }
    }
}
