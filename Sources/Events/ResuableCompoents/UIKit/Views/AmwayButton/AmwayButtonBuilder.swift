//
//  AmwayButtonBuilder.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import Foundation
import UIKit

public class AmwayButtonBuilder {
    // MARK: - Builder Data Model

    public struct AmwayButtonViewData {
        let title: String
        let image: UIImage
        let colors: AmwayButtonColors
        let textFont: UIFont
        let imageAlignment: ImageAlignment
        let contentSpacing: CGFloat
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
    }

    // MARK: - Colors Model

    public struct AmwayButtonColors {
        let textColor: UIColor
        let backgroundColor: UIColor
        let tintColor: UIColor
        let borderColor: UIColor
    }

    public enum ImageAlignment {
        case left
        case right
        case none
    }

    // MARK: - Private properties

    private(set) var title: String = ""
    private(set) var image: UIImage = UIImage()

    private(set) var colors: AmwayButtonColors =
        AmwayButtonColors(textColor: Theme.current.darkPurple.uiColor,
                          backgroundColor: .white,
                          tintColor: Theme.current.darkPurple.uiColor,
                          borderColor: Theme.current.darkPurple.uiColor)

    private(set) var textFont: UIFont = Theme.current.bodyTwoBold.uiFont
    private(set) var imageAlignment: ImageAlignment = .none
    private(set) var contentSpacing: CGFloat = .zero
    private(set) var cornerRadius: CGFloat = 0
    private(set) var borderWidth: CGFloat = 1

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setTitle(_ title: String) -> AmwayButtonBuilder {
        self.title = title
        return self
    }

    public func setImage(_ image: UIImage) -> AmwayButtonBuilder {
        self.image = image
        return self
    }

    public func setTextFont(_ textFont: UIFont) -> AmwayButtonBuilder {
        self.textFont = textFont
        return self
    }

    public func setColors(_ colors: AmwayButtonColors) -> AmwayButtonBuilder {
        self.colors = colors
        return self
    }

    public func setImageAlignment(_ imageAlignment: ImageAlignment) -> AmwayButtonBuilder {
        self.imageAlignment = imageAlignment
        return self
    }

    /// Spacing between the text and image
    public func setContentSpacing(_ contentSpacing: CGFloat) -> AmwayButtonBuilder {
        self.contentSpacing = contentSpacing
        return self
    }

    public func setCornerRadius(_ cornerRadius: CGFloat) -> AmwayButtonBuilder {
        self.cornerRadius = cornerRadius
        return self
    }

    public func setBorderWidth(_ borderWidth: CGFloat) -> AmwayButtonBuilder {
        self.borderWidth = borderWidth
        return self
    }

    public func build() -> AmwayButtonViewData {
        AmwayButtonViewData(title: title,
                            image: image,
                            colors: colors,
                            textFont: textFont,
                            imageAlignment: imageAlignment,
                            contentSpacing: contentSpacing,
                            cornerRadius: cornerRadius,
                            borderWidth: borderWidth)
    }
}
