//
//  ImageTitleSubTitleBuilder.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import UIKit

public class ImageTitleSubTitleBuilder {
    // MARK: - Builder Data Model

    public struct ImageTitleSubtitleViewData {
        let title: String
        let subTitle: String
        let image: UIImage
        let imageContentMode: UIImageView.ContentMode
        let fonts: ImageTitleSubtitleFonts
        let colors: ImageTitleSubtitleColors
        let buttonData: AmwayButtonBuilder.AmwayButtonViewData?
        let cornerRadius: CGFloat

        // Fixes for CW-4436. Need to revisit later
        func getTitleAndDescriptionViewHeight(widthOffset: CGFloat) -> CGFloat {
            let offSetValue: CGFloat = 11 // sum of (lineHeight - font.lineHeight) of  both titleFont(3) and subTitleFont(8)
            return title.heightForView(font: fonts.titleFont, width: UIScreen.main.bounds.size.width - widthOffset, lineSpacing: 3) +
                subTitle.heightForView(font: fonts.subTitleFont, width: UIScreen.main.bounds.size.width - widthOffset, lineSpacing: 8) + offSetValue
        }
    }

    // MARK: - Fonts

    public struct ImageTitleSubtitleFonts {
        let titleFont: UIFont
        let subTitleFont: UIFont
    }

    // MARK: - Colors

    public struct ImageTitleSubtitleColors {
        let titleTextColor: UIColor
        let subTitleTextColor: UIColor
        let backgroundColor: UIColor
    }

    // MARK: - Private properties

    private(set) var title: String = ""
    private(set) var subTitle: String = ""
    private(set) var image: UIImage = UIImage()
    private(set) var imageContentMode: UIImageView.ContentMode = .scaleAspectFill

    private(set) var fonts: ImageTitleSubtitleFonts = ImageTitleSubtitleFonts(titleFont: Theme.current.subtitle.uiFont,
                                                                              subTitleFont: Theme.current.bodyOneRegular.uiFont)

    private(set) var colors: ImageTitleSubtitleColors = ImageTitleSubtitleColors(titleTextColor: Theme.current.amwayBlack.uiColor,
                                                                                 subTitleTextColor: .black,
                                                                                 backgroundColor: Theme.current.amwayWhite.uiColor)
    private(set) var buttonData: AmwayButtonBuilder.AmwayButtonViewData? = AmwayButtonBuilder().build()

    private(set) var cornerRadius: CGFloat = 18

    // MARK: - Intializer

    public init() {}

    // MARK: - Public functions

    public func setTitle(_ title: String) -> ImageTitleSubTitleBuilder {
        self.title = title
        return self
    }

    public func setSubTitle(_ subTitle: String) -> ImageTitleSubTitleBuilder {
        self.subTitle = subTitle
        return self
    }

    public func setImage(_ image: UIImage) -> ImageTitleSubTitleBuilder {
        self.image = image
        return self
    }

    public func setImageViewContentMode(_ imageContentMode: UIImageView.ContentMode) -> ImageTitleSubTitleBuilder {
        self.imageContentMode = imageContentMode
        return self
    }

    public func setFonts(_ fonts: ImageTitleSubtitleFonts) -> ImageTitleSubTitleBuilder {
        self.fonts = fonts
        return self
    }

    public func setColors(_ colors: ImageTitleSubtitleColors) -> ImageTitleSubTitleBuilder {
        self.colors = colors
        return self
    }

    public func setButtonData(_ buttonData: AmwayButtonBuilder.AmwayButtonViewData?) -> ImageTitleSubTitleBuilder {
        self.buttonData = buttonData
        return self
    }

    public func setCornerRadius(_ cornerRadius: CGFloat) -> ImageTitleSubTitleBuilder {
        self.cornerRadius = cornerRadius
        return self
    }

    public func build() -> ImageTitleSubtitleViewData {
        ImageTitleSubtitleViewData(title: title,
                                   subTitle: subTitle,
                                   image: image,
                                   imageContentMode: imageContentMode,
                                   fonts: fonts,
                                   colors: colors,
                                   buttonData: buttonData,
                                   cornerRadius: cornerRadius)
    }
}
