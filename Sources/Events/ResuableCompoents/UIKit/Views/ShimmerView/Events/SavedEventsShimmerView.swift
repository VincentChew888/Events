//
//  SavedEventsShimmerView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import UIKit

final class SavedEventsShimmerView: UIView, NibLoadable {
    // MARK: - IBOutlet Properties

    @IBOutlet private var contentView: UIView!

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

private extension SavedEventsShimmerView {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
    }
}

// MARK: - Automation Ids

private extension SavedEventsShimmerView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case savedEventsShimmerView
    }

    func setupAutomationIdentifiers() {
        accessibilityIdentifier = AutomationControl.savedEventsShimmerView.accessibilityIdentifier()
    }
}
