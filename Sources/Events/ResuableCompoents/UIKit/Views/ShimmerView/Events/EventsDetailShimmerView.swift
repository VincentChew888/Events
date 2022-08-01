//
//  EventsDetailShimmerView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

final class EventsDetailShimmerView: UIView, NibLoadable {
    @IBOutlet private var eventsStatusView: UIView!
    @IBOutlet private var contentView: UIView!

    private enum Constants {
        static let grayColors: [CGColor] = [Theme.current.gray1.uiColor.cgColor,
                                            Theme.current.gray2.uiColor.cgColor,
                                            Theme.current.gray4.uiColor.cgColor]
        static let grayPoints: [CGPoint] = [CGPoint(x: 0.35, y: 0),
                                            CGPoint(x: 0.65, y: 1)]
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

        addGradientShimmer()
    }

    // MARK: - Public Methods

    func startAnimating() {
        ShimmerView.animate(view: contentView,
                            startAnimating: true)
    }

    func stopAnimating() {
        ShimmerView.animate(view: contentView,
                            startAnimating: false)
    }

    private func addGradientShimmer() {
        eventsStatusView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = eventsStatusView.bounds
        gradientLayer.frame.size.width = UIScreen.main.bounds.width
        gradientLayer.colors = Constants.grayColors
        gradientLayer.startPoint = Constants.grayPoints[0]
        gradientLayer.endPoint = Constants.grayPoints[1]
        eventsStatusView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Private Methods

private extension EventsDetailShimmerView {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
    }
}

// MARK: - Automation IDs

private extension EventsDetailShimmerView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case eventsDetailShimmerView
        case eventsStatusView
    }

    func setupAutomationIdentifiers() {
        accessibilityIdentifier = AutomationControl.eventsDetailShimmerView.accessibilityIdentifier()
        eventsStatusView.accessibilityIdentifier = AutomationControl.eventsStatusView.accessibilityIdentifier()
    }
}
