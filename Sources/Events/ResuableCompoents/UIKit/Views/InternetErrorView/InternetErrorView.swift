//
//  InternetErrorView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

final class InternetErrorView: UIView, NibLoadable {
    /// Data model for InternetErrorView
    struct InternetErrorViewData {
        var hideGlobeImage: Bool = false
        var titleTextColor: UIColor = Theme.current.amwayBlack.uiColor
        var subTitleTextColor: UIColor = Theme.current.amwayBlack.uiColor
        var backgroundColor: UIColor = .white
        var title: String = "-"
        var subTitle: String = "-"
        var globeImage: UIImage?
    }

    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var globeImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    private let internetErrorViewCornerRadius: CGFloat = 12

    lazy var data: InternetErrorViewData? = nil {
        didSet {
            setData()
            setColors()
            setFonts()
        }
    }

    required init?(coder adecoder: NSCoder) {
        super.init(coder: adecoder)

        // For using InternetErrorView in XIB
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // For using InternetErrorView in code
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorners(radius: internetErrorViewCornerRadius)
    }

    private func setUp() {
        loadFromNib()
        setupAutomationIdentifiers()
    }
}

// MARK: - Data Binding

private extension InternetErrorView {
    func setData() {
        globeImageView.isHidden = data?.hideGlobeImage ?? false
        titleLabel.attributedText = NSMutableAttributedString(string: data?.title ?? "-")
            .lineHeight(CGFloat(Theme.current.subtitle.lineHeight))
        subtitleLabel.attributedText = NSMutableAttributedString(string: data?.subTitle ?? "-")
            .lineHeight(CGFloat(Theme.current.bodyOneRegular.lineHeight))
        globeImageView.image = data?.globeImage
    }

    func setColors() {
        guard let data = data else { return }
        titleLabel.textColor = data.titleTextColor
        subtitleLabel.textColor = data.subTitleTextColor
        contentView.backgroundColor = data.backgroundColor
    }

    func setFonts() {
        titleLabel.font = Theme.current.subtitle.uiFont
        subtitleLabel.font = Theme.current.bodyOneRegular.uiFont
    }
}

// MARK: - Automation Ids

private extension InternetErrorView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case globeImage
        case titleLabel
        case subtitleLabel
    }

    func setupAutomationIdentifiers() {
        globeImageView.accessibilityIdentifier = AutomationControl.globeImage.accessibilityIdentifier()
        titleLabel.accessibilityIdentifier = AutomationControl.titleLabel.accessibilityIdentifier()
        subtitleLabel.accessibilityIdentifier = AutomationControl.subtitleLabel.accessibilityIdentifier()
    }
}
