//
//  AmwayButtonSUIBuilder.swift
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

public class AmwayButtonSUIBuilder {
    // MARK: - Builder Data Model

    public struct AmwayButtonViewData {
        let title: String
        let height: CGFloat
        let width: CGFloat
        let padding: CGFloat
        let cornerRadius: CGFloat
        let backroundColor: Color
        let foregroundColor: Color
        let font: UIFont
        let lineHeight: CGFloat
    }

    // MARK: - Private properties

    private(set) var title: String = ""
    private(set) var height: CGFloat = 36.0
    private(set) var width: CGFloat = .infinity
    private(set) var padding: CGFloat = 16.0
    private(set) var cornerRadius: CGFloat = 24.0
    private(set) var backroundColor: Color = Theme.current.amwayBlack.color
    private(set) var foregroundColor: Color = Theme.current.amwayWhite.color
    private(set) var font: UIFont = Theme.current.bodyTwoBold.uiFont
    private(set) var lineHeight: CGFloat = Theme.current.bodyTwoBold.lineHeight

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setTitle(_ title: String) -> AmwayButtonSUIBuilder {
        self.title = title
        return self
    }

    public func setHeight(_ height: CGFloat) -> AmwayButtonSUIBuilder {
        self.height = height
        return self
    }

    public func setWidth(_ width: CGFloat) -> AmwayButtonSUIBuilder {
        self.width = width
        return self
    }

    public func setPadding(_ padding: CGFloat) -> AmwayButtonSUIBuilder {
        self.padding = padding
        return self
    }

    public func setCornerRadius(_ cornerRadius: CGFloat) -> AmwayButtonSUIBuilder {
        self.cornerRadius = cornerRadius
        return self
    }

    public func setBackroundColor(_ backroundColor: Color) -> AmwayButtonSUIBuilder {
        self.backroundColor = backroundColor
        return self
    }

    public func setForegroundColor(_ foregroundColor: Color) -> AmwayButtonSUIBuilder {
        self.foregroundColor = foregroundColor
        return self
    }

    public func setLineHeight(_ lineHeight: CGFloat) -> AmwayButtonSUIBuilder {
        self.lineHeight = lineHeight
        return self
    }

    public func setFont(_ font: UIFont) -> AmwayButtonSUIBuilder {
        self.font = font
        return self
    }

    public func build() -> AmwayButtonViewData {
        AmwayButtonViewData(title: title,
                            height: height,
                            width: width,
                            padding: padding,
                            cornerRadius: cornerRadius,
                            backroundColor: backroundColor,
                            foregroundColor: foregroundColor,
                            font: font,
                            lineHeight: lineHeight)
    }
}
