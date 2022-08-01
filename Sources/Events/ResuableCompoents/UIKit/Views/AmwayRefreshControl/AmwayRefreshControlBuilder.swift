//
//  AmwayRefreshControlBuilder.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

class AmwayRefreshControlBuilder {
    // MARK: - Builder Data Model

    struct AmwayRefreshControlData {
        let innerCircleColor: UIColor
        let outerCircleColor: UIColor
        let fillColor: UIColor
    }

    // MARK: - Private properties

    private(set) var innerCircleColor: UIColor = Theme.current.loaderBackgroundColor.uiColor
    private(set) var outerCircleColor: UIColor = Theme.current.amwayWhite.uiColor
    private(set) var fillColor: UIColor = .clear

    // MARK: - Intializer

    init() {}

    // MARK: - Public functions

    func setInnerCircleColor(_ innerCircleColor: UIColor) -> AmwayRefreshControlBuilder {
        self.innerCircleColor = innerCircleColor
        return self
    }

    func setOuterCircleColor(_ outerCircleColor: UIColor) -> AmwayRefreshControlBuilder {
        self.outerCircleColor = outerCircleColor
        return self
    }

    func setFillColor(_ fillColor: UIColor) -> AmwayRefreshControlBuilder {
        self.fillColor = fillColor
        return self
    }

    func build() -> AmwayRefreshControlData {
        AmwayRefreshControlData(innerCircleColor: innerCircleColor,
                                outerCircleColor: outerCircleColor,
                                fillColor: fillColor)
    }
}
