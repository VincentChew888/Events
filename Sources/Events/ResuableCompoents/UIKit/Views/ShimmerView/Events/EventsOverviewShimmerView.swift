//
//  EventsOverviewShimmerView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

final class EventsOverviewShimmerView: UIView, NibLoadable {
    // MARK: - IBOutlet Properties

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var segmentShimmerView: ShimmerView!

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
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
}

// MARK: - Private Methods

private extension EventsOverviewShimmerView {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
        segmentShimmerView.roundCorners(for: [.topLeft, .bottomLeft],
                                        radius: segmentShimmerView.bounds.height / 2)
        setupAutomationIdentifiers()
        backgroundColor = .red
    }
}

// MARK: - Automation Ids

private extension EventsOverviewShimmerView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case eventsOverviewShimmerView
    }

    func setupAutomationIdentifiers() {
        accessibilityIdentifier = AutomationControl.eventsOverviewShimmerView.accessibilityIdentifier()
    }
}
