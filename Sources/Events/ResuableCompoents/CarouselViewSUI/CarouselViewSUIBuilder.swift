//
//  CarouselViewSUIBuilder.swift
//  Events
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

/// CarouselViewSUIBuilder can be used to modify properties for our view eg.  singleItemCellHeight , cellPadding, spacing in two cells.
public class CarouselViewSUIBuilder {
    // MARK: - Builder Data Model

    public struct CarouselViewSUIData {
        let spacing: CGFloat
        let cellPadding: CGFloat
        let singleItemCellHeight: CGFloat
        let multipleItemCellHeight: CGFloat
        let multipleItemCellWidth: CGFloat
    }

    // MARK: - Private properties

    private(set) var spacing: CGFloat = 8.0
    private(set) var cellPadding: CGFloat = 16.0
    private(set) var singleItemCellHeight: CGFloat = 273
    private(set) var multipleItemCellHeight: CGFloat = 240
    private(set) var multipleItemCellWidth: CGFloat = 284

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setSpacing(_ spacing: CGFloat) -> CarouselViewSUIBuilder {
        self.spacing = spacing
        return self
    }

    public func setCellPadding(_ cellPadding: CGFloat) -> CarouselViewSUIBuilder {
        self.cellPadding = cellPadding
        return self
    }

    public func setSingleItemCellHeight(_ singleItemCellHeight: CGFloat) -> CarouselViewSUIBuilder {
        self.singleItemCellHeight = singleItemCellHeight
        return self
    }

    public func setMultipleItemCellHeight(_ multipleItemCellHeight: CGFloat) -> CarouselViewSUIBuilder {
        self.multipleItemCellHeight = multipleItemCellHeight
        return self
    }

    /// Spacing between the text and image
    public func setMultipleItemCellWidth(_ multipleItemCellWidth: CGFloat) -> CarouselViewSUIBuilder {
        self.multipleItemCellWidth = multipleItemCellWidth
        return self
    }

    public func build() -> CarouselViewSUIData {
        CarouselViewSUIData(spacing: spacing,
                            cellPadding: cellPadding,
                            singleItemCellHeight: singleItemCellHeight,
                            multipleItemCellHeight: multipleItemCellHeight,
                            multipleItemCellWidth: multipleItemCellWidth)
    }
}
