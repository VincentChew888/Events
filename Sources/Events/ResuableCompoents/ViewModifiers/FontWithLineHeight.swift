//
//  FontWithLineHeight.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

// Reference: https://stackoverflow.com/a/64652348

// TODO: Move this modifier to AmwayThemeKit package.
public struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat
    let verticalPadding: CGFloat

    public func body(content: Content) -> some View {
        content
            .font(Font(font as CTFont))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, ((lineHeight - font.lineHeight) / 2) + verticalPadding)
    }
}
