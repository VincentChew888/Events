//
//  ImageTitleSubtitleView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

public final class ImageTitleSubtitleView: UIView {
    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var button: AmwayButton!
    @IBOutlet private var stackView: UIStackView!

    var data: ImageTitleSubTitleBuilder.ImageTitleSubtitleViewData? {
        didSet {
            setData()
            setColors()
            setFonts()
        }
    }

    var buttonAction: (() -> Void)?

    private let nibName = "ImageTitleSubtitleView"
    private let cornerRadiusValue: CGFloat = 18
    required init?(coder adecoder: NSCoder) {
        super.init(coder: adecoder)
        // For using ImageTitleSubtitleView in XIB
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // For using ImageTitleSubtitleView in code
        setupView()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: data?.cornerRadius ?? cornerRadiusValue)
    }

    private func setupView() {
        loadFromNib()
    }

    @IBAction private func buttonClicked(sender _: Any) {
        buttonAction?()
    }
}

// MARK: - NIB Loadable

extension ImageTitleSubtitleView: NibLoadable {}

// MARK: - Data Binding

private extension ImageTitleSubtitleView {
    func setData() {
        guard let data = data else { return }

        let titleText = data.title
        let titleLabelLineHeight = Theme.current.subtitle.lineHeight
        titleLabel.attributedText = NSMutableAttributedString(string: titleText)
            .lineHeight(titleLabelLineHeight)
        let subTitleText = data.subTitle
        let subTitleLabelLineHeight = Theme.current.bodyOneRegular.lineHeight
        subtitleLabel.attributedText = NSMutableAttributedString(string: subTitleText)
            .lineHeight(subTitleLabelLineHeight)
        imageView.image = data.image
        imageView.contentMode = data.imageContentMode
        if let buttonData = data.buttonData {
            button.isHidden = false
            button.setData(data: buttonData)
        } else {
            button.isHidden = true
        }
        stackView.setCustomSpacing(8.0, after: titleLabel)
        roundCorners(radius: data.cornerRadius)
    }

    func setColors() {
        guard let data = data else { return }
        titleLabel.textColor = data.colors.titleTextColor
        subtitleLabel.textColor = data.colors.subTitleTextColor
        contentView.backgroundColor = data.colors.backgroundColor
    }

    func setFonts() {
        guard let data = data else { return }
        titleLabel.font = data.fonts.titleFont
        subtitleLabel.font = data.fonts.subTitleFont
    }
}

// MARK: - Automation Ids

extension ImageTitleSubtitleView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case imageView = "ImageView"
        case titleLabel = "TitleLabel"
        case subtitleLabel = "SubtitleLabel"
        case button = "Button"
    }

    enum SectionType: String {
        case group
        case customers
        case shareableContent
        case programPerformance
        case leads
    }

    enum ButtonType: String {
        case viewGroup
        case startLessonCustomers
        case goToiShare
        case addCustomers
        case newLead
    }

    func setupAutomationIdentifiers(sectionType: SectionType, buttonType: ButtonType) {
        imageView.isAccessibilityElement = true
        let sectionTitle = sectionType.rawValue
        let buttonTitle = buttonType.rawValue
        imageView.accessibilityIdentifier = "\(sectionTitle)\(AutomationControl.imageView.rawValue)"
        titleLabel.accessibilityIdentifier = "\(sectionTitle)\(AutomationControl.titleLabel.rawValue)"
        subtitleLabel.accessibilityIdentifier = "\(sectionTitle)\(AutomationControl.subtitleLabel.rawValue)"
        button.accessibilityIdentifier = "\(buttonTitle)\(AutomationControl.button.rawValue)"
    }
}
