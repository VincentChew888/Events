//
//  AmwayButton.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import UIKit

/// Button with customisations for character spacing and image alignment.
final class AmwayButton: UIControl, NibLoadable {
    @IBInspectable public var characterSpacing: CGFloat = 1 {
        didSet {
            updateWithAttributes()
        }
    }

    enum TouchState {
        case idle
        case down
        case up
        case cancelled
    }

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageViewLeft: UIImageView!
    @IBOutlet private var imageViewRight: UIImageView!

    private var imageAlignment: AmwayButtonBuilder.ImageAlignment = .none
    private var contentSpacing: CGFloat = .zero
    private var touchState: TouchState = .idle {
        didSet {
            guard touchState != oldValue else { return }
            switch touchState {
            case .idle:
                break
            case .down:
                performTouchDownAnimations()
            case .up:
                performTouchUpAnimations()
            case .cancelled:
                performTouchCancelledAnimations()
            }
        }
    }

    private var extendedBounds: CGRect { bounds.insetBy(dx: -70, dy: -70) }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        setInsets()
    }

    func setAttributedTitle(_ attributedString: NSAttributedString) {
        titleLabel.attributedText = attributedString
    }

    func setTitleFont(_ font: UIFont) {
        titleLabel.font = font
    }

    func setData(data: AmwayButtonBuilder.AmwayButtonViewData?) {
        guard let data = data else { return }

        titleLabel.text = data.title
        imageViewLeft.image = data.image
        imageViewRight.image = data.image
        backgroundColor = data.colors.backgroundColor
        tintColor = data.colors.tintColor
        titleLabel?.font = data.textFont
        titleLabel.textColor = data.colors.textColor
        borderWidth = data.borderWidth
        borderColor = data.colors.borderColor
        imageAlignment = data.imageAlignment
        contentSpacing = data.contentSpacing
        cornerRadius = data.cornerRadius == 0 ? bounds.height / 2 : data.cornerRadius
        setInsets()
    }

    private func setup() {
        loadFromNib(needSafeAreaInset: false)
        setupAutomationIdentifiers()
    }

    /// Method to set insets to the image and text based on the alignment of the image to the text and the spacing between them.
    private func setInsets() {
        guard imageViewLeft.image != nil else {
            return
        }

        switch imageAlignment {
        case .left:
            imageViewRight.isHidden = true
            imageViewLeft.isHidden = false
        case .right:
            imageViewRight.isHidden = false
            imageViewLeft.isHidden = true
        case .none:
            return
        }
    }

    private func updateWithAttributes() {
        guard let reqText = titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: reqText)
        let reqRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: reqRange)
        titleLabel.attributedText = attributedString
    }

    // MARK: - Tracking Methods for Custom Animation

    override func beginTracking(_: UITouch, with _: UIEvent?) -> Bool {
        guard touchState == .idle else { return false }
        touchState = .down
        return true
    }

    override func continueTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        if extendedBounds.contains(point) {
            touchState = .down
        } else {
            touchState = .cancelled
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if let point = touch?.location(in: self), extendedBounds.contains(point) {
            touchState = .up
        } else {
            touchState = .cancelled
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        touchState = .cancelled
    }

    // MARK: - Custom Animations

    private func performTouchDownAnimations() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.stackView.alpha = 0.5
        } completion: { _ in
            self.touchState = .idle
        }
    }

    private func performTouchUpAnimations() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.stackView.alpha = 1.0
        } completion: { _ in
            self.touchState = .idle
        }
    }

    private func performTouchCancelledAnimations() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.stackView.alpha = 1.0
        } completion: { _ in
            self.touchState = .idle
        }
    }
}

// MARK: - Automation Ids

private extension AmwayButton {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case stackView
        case titleLabel
        case imageViewLeft
        case imageViewRight
    }

    func setupAutomationIdentifiers() {
        stackView.accessibilityIdentifier = AutomationControl.stackView.accessibilityIdentifier()
        titleLabel.accessibilityIdentifier = AutomationControl.titleLabel.accessibilityIdentifier()
        imageViewLeft.accessibilityIdentifier = AutomationControl.imageViewLeft.accessibilityIdentifier()
        imageViewRight.accessibilityIdentifier = AutomationControl.imageViewRight.accessibilityIdentifier()
    }
}
