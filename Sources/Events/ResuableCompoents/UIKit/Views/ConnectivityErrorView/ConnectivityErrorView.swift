//
//  ConnectivityErrorView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

protocol ConnectivityErrorViewDelegate: AnyObject {
    func didTapOnTryAgain()
}

final class ConnectivityErrorView: UIView, NibLoadable {
    struct ConnectivityErrorViewData {
        var titleTextColor: UIColor = Theme.current.amwayBlack.uiColor
        var backgroundColor: UIColor = .white
        var buttonData: AmwayButtonBuilder.AmwayButtonViewData
        var title: String = "-"
    }

    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tryAgainButton: AmwayButton!

    private let connectivityErrorViewCornerRadius: CGFloat = 12

    lazy var data: ConnectivityErrorViewData? = nil {
        didSet {
            setData()
            setColors()
            setFonts()
        }
    }

    weak var delegate: ConnectivityErrorViewDelegate?

    required init?(coder adecoder: NSCoder) {
        super.init(coder: adecoder)

        // For using ConnectivityErrorView in XIB
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // For using ConnectivityErrorView in code
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorners(radius: connectivityErrorViewCornerRadius)
    }

    private func setUp() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
    }

    @IBAction private func buttonClicked(_: Any) {
        delegate?.didTapOnTryAgain()
    }
}

// MARK: - Data Binding

private extension ConnectivityErrorView {
    func setData() {
        guard let data = data else { return }
        titleLabel.attributedText = NSMutableAttributedString(string: data.title)
            .lineHeight(CGFloat(Theme.current.bodyOneRegular.lineHeight))

        tryAgainButton.setData(data: data.buttonData)
    }

    func setColors() {
        guard let data = data else { return }
        titleLabel.textColor = data.titleTextColor
        contentView.backgroundColor = data.backgroundColor
    }

    func setFonts() {
        titleLabel.font = Theme.current.bodyOneRegular.uiFont
    }
}

// MARK: - Automation Ids

private extension ConnectivityErrorView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case titleLabel
        case tryAgainButton
    }

    func setupAutomationIdentifiers() {
        titleLabel.accessibilityIdentifier = AutomationControl.titleLabel.accessibilityIdentifier()
        tryAgainButton.accessibilityIdentifier = AutomationControl.tryAgainButton.accessibilityIdentifier()
    }
}
