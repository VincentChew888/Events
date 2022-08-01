//
//  CircularLoadingViewBuilder.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

class CircularLoadingViewBuilder {
    // MARK: - Builder Data Model

    struct CircularLoadingViewData {
        let colors: CircularLoadingViewColors
        let lineWidth: CGFloat
        let lineCap: CAShapeLayerLineCap
        let strokeStartAnimation: StrokeAnimation
        let strokeEndAnimation: StrokeAnimation
        let strokeAnimationDuration: CFTimeInterval
        let strokeAnimationRepeatDuration: CFTimeInterval
        let rotationAnimation: RotationAnimation
    }

    struct CircularLoadingViewColors {
        let backgroundLayerColor: UIColor
        let foregroundLayerColor: UIColor
        let fillColor: UIColor
    }

    struct StrokeAnimation {
        let keyPath: StrokeAnimationKeyPath
        let beginTime: CFTimeInterval
        let fromValue: CGFloat = 0.0
        let toValue: CGFloat = 1.0
        let duration: CFTimeInterval = 0.75
        let timingFunction: CAMediaTimingFunction = .init(name: .easeInEaseOut)

        enum StrokeAnimationKeyPath: String {
            case strokeStart
            case strokeEnd
        }
    }

    struct RotationAnimation {
        let keyPath: RotationAnimationKeyPath
        let fromValue: CGFloat
        let toValue: CGFloat
        let duration: CFTimeInterval
        let repeatCount: Float

        enum RotationAnimationKeyPath: String {
            case rotateX = "transform.rotation.x"
            case rotateY = "transform.rotation.y"
            case rotateZ = "transform.rotation.z"
        }
    }

    // MARK: - Private properties

    private(set) var colors: CircularLoadingViewColors =
        CircularLoadingViewColors(backgroundLayerColor: Theme.current.loaderBackgroundColor.uiColor,
                                  foregroundLayerColor: Theme.current.amwayWhite.uiColor,
                                  fillColor: .clear)
    private(set) var lineWidth: CGFloat = 4
    private(set) var lineCap: CAShapeLayerLineCap = .round
    private(set) var strokeStartAnimation: StrokeAnimation =
        StrokeAnimation(keyPath: .strokeStart,
                        beginTime: 0.5)
    private(set) var strokeEndAnimation: StrokeAnimation =
        StrokeAnimation(keyPath: .strokeEnd,
                        beginTime: 0.0)
    private(set) var rotationAnimation: RotationAnimation =
        RotationAnimation(keyPath: .rotateZ,
                          fromValue: 0,
                          toValue: .pi * 2,
                          duration: 2.0,
                          repeatCount: .greatestFiniteMagnitude)
    private(set) var strokeAnimationDuration: CFTimeInterval = 1.0
    private(set) var strokeAnimationRepeatDuration: CFTimeInterval = .infinity

    // MARK: - Intializer

    init() {}

    // MARK: - Public functions

    func setColors(_ colors: CircularLoadingViewColors) -> CircularLoadingViewBuilder {
        self.colors = colors
        return self
    }

    func setLineWidth(_ lineWidth: CGFloat) -> CircularLoadingViewBuilder {
        self.lineWidth = lineWidth
        return self
    }

    func setLineCap(_ lineCap: CAShapeLayerLineCap) -> CircularLoadingViewBuilder {
        self.lineCap = lineCap
        return self
    }

    func setStrokeStartAnimation(_ strokeStartAnimation: StrokeAnimation) -> CircularLoadingViewBuilder {
        self.strokeStartAnimation = strokeStartAnimation
        return self
    }

    func setStrokeEndAnimation(_ strokeEndAnimation: StrokeAnimation) -> CircularLoadingViewBuilder {
        self.strokeEndAnimation = strokeEndAnimation
        return self
    }

    func setRotationAnimation(_ rotationAnimation: RotationAnimation) -> CircularLoadingViewBuilder {
        self.rotationAnimation = rotationAnimation
        return self
    }

    func setStrokeAnimationDuration(_ strokeAnimationDuration: CFTimeInterval) -> CircularLoadingViewBuilder {
        self.strokeAnimationDuration = strokeAnimationDuration
        return self
    }

    func setStrokeAnimationRepeatDuration(_ strokeAnimationRepeatDuration: CFTimeInterval) -> CircularLoadingViewBuilder {
        self.strokeAnimationRepeatDuration = strokeAnimationRepeatDuration
        return self
    }

    func build() -> CircularLoadingViewData {
        CircularLoadingViewData(colors: colors,
                                lineWidth: lineWidth,
                                lineCap: lineCap,
                                strokeStartAnimation: strokeStartAnimation,
                                strokeEndAnimation: strokeEndAnimation,
                                strokeAnimationDuration: strokeAnimationDuration,
                                strokeAnimationRepeatDuration: strokeAnimationRepeatDuration,
                                rotationAnimation: rotationAnimation)
    }
}
