//
//  AmwayButtonSUI.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//
import AmwayThemeKit
import SwiftUI

struct AmwayButtonSUI: View {
    // MARK: - Properties

    var data: AmwayButtonSUIBuilder.AmwayButtonViewData
    var onTapAction: (() -> Void)?

    // MARK: - View

    var body: some View {
        Button {
            onTapAction?()
        } label: {
            Text(data.title)
                .frame(maxWidth: data.width)
                .padding(data.padding)
                .background(data.backroundColor)
                .foregroundColor(data.foregroundColor)
                .fontWithLineHeight(font: data.font,
                                    lineHeight: data.lineHeight,
                                    verticalPadding: 0)
        }
        .frame(height: data.height)
        .cornerRadius(data.cornerRadius)
        .padding(.horizontal, data.padding)
    }
}
