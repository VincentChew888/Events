//
//  ConnectivityErrorViewBuilder.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import Foundation
import UIKit

public class ConnectivityErrorViewBuilder {
    // MARK: - Builder Data Model

    public struct ConnectivityErrorData {
        let colors: AmwayButtonBuilder.AmwayButtonColors
        let textColor: UIColor
        let backgroundColor: UIColor
    }

    // MARK: - Private properties

    private(set) var colors: AmwayButtonBuilder.AmwayButtonColors =
        AmwayButtonBuilder.AmwayButtonColors(textColor: Theme.current.darkPurple.uiColor,
                                             backgroundColor: .white,
                                             tintColor: Theme.current.darkPurple.uiColor,
                                             borderColor: Theme.current.darkPurple.uiColor)

    private(set) var textColor: UIColor = Theme.current.amwayBlack.uiColor
    private(set) var backgroundColor: UIColor = .white

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setTextColor(_ textColor: UIColor) -> ConnectivityErrorViewBuilder {
        self.textColor = textColor
        return self
    }

    public func setBackgroundColor(_ backgroundColor: UIColor) -> ConnectivityErrorViewBuilder {
        self.backgroundColor = backgroundColor
        return self
    }

    public func setColors(_ colors: AmwayButtonBuilder.AmwayButtonColors) -> ConnectivityErrorViewBuilder {
        self.colors = colors
        return self
    }

    public func build() -> ConnectivityErrorData {
        ConnectivityErrorData(colors: colors,
                              textColor: textColor,
                              backgroundColor: backgroundColor)
    }
}
