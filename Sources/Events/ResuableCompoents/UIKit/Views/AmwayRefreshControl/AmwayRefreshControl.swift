//
//  AmwayRefreshControl.swift
//  Amway
//
//  Copyright (c) 2021 Amway. All rights reserved.

import UIKit

final class AmwayRefreshControl: UIRefreshControl, NibLoadable {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var circularLoadingView: CircularLoadingView!
    @IBOutlet private var heightConstraintForContainerView: NSLayoutConstraint!
    @IBOutlet private var topConstraintForCircularLoadingView: NSLayoutConstraint!
    @IBOutlet private var bottomConstraintForCircularLoadingView: NSLayoutConstraint!

    var data: AmwayRefreshControlBuilder.AmwayRefreshControlData? {
        didSet {
            setCircularLoadingViewData()
        }
    }

    private let maxPullDistance: CGFloat = 150
    // panDistance = height of CircularLoadingView
    //               + CircularLoadingView topconstratint to containerView constant
    //               + CircularLoadingView bottomConstraint to containerView constant
    private let panDistanceToTop: CGFloat = 64

    override init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override func beginRefreshing() {
        super.beginRefreshing()

        circularLoadingView.isAnimating = true
    }

    override func endRefreshing() {
        super.endRefreshing()

        circularLoadingView.isAnimating = false
    }

    // MARK: - Public Methods

    func updateProgress(with offsetY: CGFloat) {
        guard !circularLoadingView.isAnimating else { return }

        let progress = min(abs(offsetY / maxPullDistance), 1)
        circularLoadingView.updateProgress(with: progress)

        // offsetY is comes as negative when we pull, hence taking absolute value to add get postive value.
        // Default: topConstraint priority is low, bottomConstraint Priority is High
        // Reason: Pulling the refresh control will pull the circularViw From above without maintaining its top Constraint.
        // Logic: in `if` block Pulling beyond `panDistanceToTop` will make sure the CircularView Maintains it top constraint,
        // without maintaining the bottom space.
        heightConstraintForContainerView.constant = abs(offsetY)
        if abs(offsetY) > panDistanceToTop {
            // Keeping the top constraint priority high to keep the distance from top fixed.
            // Keeping the bottom constraint priority low to avoid the fixed distance from bottom.
            bottomConstraintForCircularLoadingView.priority = .defaultLow
            topConstraintForCircularLoadingView.priority = .defaultHigh
        } else {
            // Vice-versa
            topConstraintForCircularLoadingView.priority = .defaultLow
            bottomConstraintForCircularLoadingView.priority = .defaultHigh
        }
        containerView.layoutIfNeeded()
    }
}

// MARK: - Private Methods

private extension AmwayRefreshControl {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
        additionalSetup()
    }

    func additionalSetup() {
        heightConstraintForContainerView.constant = 0
        tintColor = .clear
        addTarget(self,
                  action: #selector(beginRefreshing),
                  for: .valueChanged)
    }

    func setCircularLoadingViewData() {
        guard let innerCircleColor = data?.innerCircleColor,
              let outerCircleColor = data?.outerCircleColor,
              let fillColor = data?.fillColor else { return }

        let circularLoadingViewData = CircularLoadingViewBuilder()
            .setColors(CircularLoadingViewBuilder.CircularLoadingViewColors(backgroundLayerColor: innerCircleColor,
                                                                            foregroundLayerColor: outerCircleColor,
                                                                            fillColor: fillColor))
            .build()
        circularLoadingView.data = circularLoadingViewData
    }
}

// MARK: - Automation Ids

private extension AmwayRefreshControl {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case refreshControl
    }

    func setupAutomationIdentifiers() {
        accessibilityIdentifier = AutomationControl.refreshControl.accessibilityIdentifier()
    }
}
