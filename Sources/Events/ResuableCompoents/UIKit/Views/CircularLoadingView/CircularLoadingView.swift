//
//  CircularLoadingView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import UIKit

class CircularLoadingView: UIView {
    var data: CircularLoadingViewBuilder.CircularLoadingViewData? {
        didSet {
            setupSublayers()
        }
    }

    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }

    private var backgroundShapeLayer: CAShapeLayer = CAShapeLayer()
    private var foregroundShapeLayer: CAShapeLayer = CAShapeLayer()

    // MARK: - Public Methods

    /// Method to update the progress of the outer circle with the given progress value
    /// - Parameter progress: The progress value
    func updateProgress(with progress: CGFloat) {
        foregroundShapeLayer.strokeEnd = progress
    }
}

// MARK: - Private Methods

private extension CircularLoadingView {
    func setupSublayers() {
        let path = UIBezierPath(ovalIn: CGRect(x: .zero,
                                               y: .zero,
                                               width: bounds.width,
                                               height: bounds.height))
        setupBackgroundShapeLayer(path: path)
        setupForegroundShapeLayer(path: path)
        layer.addSublayer(backgroundShapeLayer)
        layer.addSublayer(foregroundShapeLayer)
    }

    func setupBackgroundShapeLayer(path: UIBezierPath) {
        backgroundShapeLayer.strokeColor = data?.colors.backgroundLayerColor.cgColor
        backgroundShapeLayer.fillColor = data?.colors.fillColor.cgColor
        backgroundShapeLayer.lineWidth = data?.lineWidth ?? .zero
        backgroundShapeLayer.lineCap = data?.lineCap ?? .round
        backgroundShapeLayer.path = path.cgPath
    }

    func setupForegroundShapeLayer(path: UIBezierPath) {
        foregroundShapeLayer.strokeColor = data?.colors.foregroundLayerColor.cgColor
        foregroundShapeLayer.fillColor = data?.colors.fillColor.cgColor
        foregroundShapeLayer.lineWidth = data?.lineWidth ?? .zero
        foregroundShapeLayer.lineCap = data?.lineCap ?? .round
        foregroundShapeLayer.path = path.cgPath
    }

    func startAnimation() {
        animateStroke()
        animateRotation()
    }

    func stopAnimation() {
        foregroundShapeLayer.removeAllAnimations()
        layer.removeAllAnimations()
    }

    func animateStroke() {
        let startAnimation = createBasicAnimation(with: data?.strokeStartAnimation)
        let endAnimation = createBasicAnimation(with: data?.strokeEndAnimation)

        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = data?.strokeAnimationDuration ?? .zero
        strokeAnimationGroup.repeatDuration = data?.strokeAnimationRepeatDuration ?? .zero
        strokeAnimationGroup.animations = [startAnimation,
                                           endAnimation]

        foregroundShapeLayer.add(strokeAnimationGroup,
                                 forKey: nil)
    }

    func animateRotation() {
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = data?.rotationAnimation.keyPath.rawValue
        rotationAnimation.fromValue = data?.rotationAnimation.fromValue
        rotationAnimation.toValue = data?.rotationAnimation.toValue
        rotationAnimation.duration = data?.rotationAnimation.duration ?? .zero
        rotationAnimation.repeatCount = data?.rotationAnimation.repeatCount ?? .zero

        layer.add(rotationAnimation,
                  forKey: nil)
    }

    func createBasicAnimation(with strokeAnimation: CircularLoadingViewBuilder.StrokeAnimation?) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = strokeAnimation?.keyPath.rawValue
        animation.beginTime = strokeAnimation?.beginTime ?? .zero
        animation.fromValue = strokeAnimation?.fromValue
        animation.toValue = strokeAnimation?.toValue
        animation.duration = strokeAnimation?.duration ?? .zero
        animation.timingFunction = strokeAnimation?.timingFunction
        return animation
    }
}
