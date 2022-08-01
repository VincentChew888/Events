//
//  ShimmerBlockView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import UIKit

final class ShimmerBlockView: UIView, NibLoadable {
    @IBOutlet private var shimmerView: ShimmerView!

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let shimmerViewCornerRadius: CGFloat = 8
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

        cornerRadius = Constants.cornerRadius
        shimmerView.cornerRadius = Constants.shimmerViewCornerRadius
    }

    // MARK: - Public Methods

    func startAnimating() {
        shimmerView.startAnimating()
    }

    func stopAnimating() {
        shimmerView.stopAnimating()
    }
}

// MARK: - Private Methods

private extension ShimmerBlockView {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
    }
}

// MARK: - Automation Ids

private extension ShimmerBlockView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case shimmerView
        case shimmerBlockView
    }

    func setupAutomationIdentifiers() {
        shimmerView.accessibilityIdentifier = AutomationControl.shimmerView.accessibilityIdentifier()
        accessibilityIdentifier = AutomationControl.shimmerBlockView.accessibilityIdentifier()
    }
}
