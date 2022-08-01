//
//  ShimmerView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import Foundation
import UIKit

final class ShimmerView: UIView {
    @IBInspectable var colorsIndex: Int = 0 {
        didSet {
            let index = min(Constants.gradientColors.count - 1, colorsIndex)
            gradientLayer.colors = Constants.gradientColors[index]
        }
    }

    private let gradientLayer = CAGradientLayer()

    private enum Constants {
        static let startOffset: CGFloat = 0.0
        static let midOffset: CGFloat = 0.5
        static let endOffset: CGFloat = 1.0
        static let locationsKeyPath = "locations"
        static let layerLocations: [NSNumber] = [0.0,
                                                 0.5,
                                                 1.0]
        static let animationDuration: TimeInterval = 0.9
        static let animationRepeatCount: Float = .infinity
        static let gradientColors = [[Theme.current.gray2.uiColor.cgColor,
                                      Theme.current.gray1.uiColor.cgColor,
                                      Theme.current.gray2.uiColor.cgColor],
                                     [Theme.current.primaryPurpleGradient.uiColor.cgColor,
                                      Theme.current.secondaryPurpleGradient.uiColor.cgColor,
                                      Theme.current.darkPurple.uiColor.cgColor],
                                     [Theme.current.darkPurple.uiColor.cgColor,
                                      Theme.current.secondaryPurpleGradient.uiColor.cgColor,
                                      Theme.current.primaryPurpleGradient.uiColor.cgColor]]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Public Methods

    func startAnimating() {
        animateGradientLayer()
    }

    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }

    static func animate(view: UIView, startAnimating: Bool) {
        if view.subviews.isEmpty {
            if let view = view as? ShimmerView {
                startAnimating ? view.startAnimating() : view.stopAnimating()
            }
            if let view = view as? ShimmerBlockView {
                startAnimating ? view.startAnimating() : view.stopAnimating()
            }
        } else {
            view.subviews.forEach { ShimmerView.animate(view: $0,
                                                        startAnimating: startAnimating) }
        }
    }

    func setGradientColors(colors: [UIColor], locations: [NSNumber]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
    }
}

// MARK: - Private Methods

private extension ShimmerView {
    func setup() {
        clipsToBounds = true
        setupGradientLayer()
    }

    func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: Constants.startOffset,
                                           y: Constants.endOffset)
        gradientLayer.endPoint = CGPoint(x: Constants.endOffset,
                                         y: Constants.endOffset)
        let index = min(Constants.gradientColors.count - 1, colorsIndex)
        gradientLayer.colors = Constants.gradientColors[index]
        gradientLayer.locations = Constants.layerLocations
        layer.addSublayer(gradientLayer)
    }

    func animateGradientLayer() {
        let animation = CABasicAnimation(keyPath: Constants.locationsKeyPath)
        animation.fromValue = [-Constants.endOffset,
                               -Constants.midOffset,
                               Constants.startOffset]
        animation.toValue = [Constants.endOffset,
                             Constants.endOffset + Constants.midOffset,
                             2 * Constants.endOffset]
        animation.repeatCount = Constants.animationRepeatCount
        animation.duration = Constants.animationDuration
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation,
                          forKey: animation.keyPath)
    }
}
