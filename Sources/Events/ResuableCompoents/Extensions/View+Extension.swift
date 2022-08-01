//
//  View+Extension.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder internal func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }

    func addToolBarButton(placement: ToolbarItemPlacement = .navigationBarTrailing,
                          buttonAction: (() -> Void)? = nil,
                          image: UIImage? = nil,
                          accessibilityIdentifier: String? = nil) -> some View
    {
        toolbar {
            ToolbarItem(placement: placement) {
                Button {
                    buttonAction?()
                } label: {
                    Image(uiImage: image ?? UIImage())
                }.accessibilityIdentifier(accessibilityIdentifier ?? "")
            }
        }
    }

    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)

        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]

        return self
    }

    internal func onRefresh(refreshControlData: AmwayRefreshControlBuilder.AmwayRefreshControlData = AmwayRefreshControlBuilder().build(),
                            onValueChanged: @escaping (UIRefreshControl) -> Void) -> some View
    {
        modifier(OnListRefreshModifier(refreshControlData: refreshControlData,
                                       onValueChanged: onValueChanged))
    }

    /// ViewModifier to set a given Font and a given Line Height to the View.
    /// The Vertical Padding parameter is also considered as the .padding modifier is used to set the Line Height.
    ///
    /// - Parameters:
    ///   - font: The font to be set.
    ///   - lineHeight: The line height to be set.
    ///   - verticalPadding: The vertical padding to be set.
    /// - Returns: The modified view.
    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat, verticalPadding: CGFloat) -> some View {
        ModifiedContent(content: self,
                        modifier: FontWithLineHeight(font: font,
                                                     lineHeight: lineHeight,
                                                     verticalPadding: verticalPadding))
    }

    func navigationBarColor(backgroundColor: UIColor, textColor: UIColor) -> some View {
        modifier(NavigationBarColorModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}
