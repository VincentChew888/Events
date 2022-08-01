//
//  ToastView+Extension.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

// MARK: - Nested types

extension ToastView {
    enum Constant {
        static let borderWidth = 1.0
    }

    public struct ViewData {
        let rect: CGRect
        let fetchError: Bool
        let messageData: DisplayData
        public let seconds: Double = 2
        let cornerRadius: CGFloat = 10
    }

    struct DisplayData {
        let title: String
        var type: ToastType = .success
        let toastDescription: String
    }
}

// MARK: - ToastType enum to identify colors and image for different state.

extension ToastView {
    enum ToastType {
        case success, failure

        var bgColor: Color {
            var color: Color
            switch self {
            case .success:
                color = Theme.current.success1.color
            case .failure:
                color = Theme.current.error20.color
            }
            return color
        }

        var borderColor: Color {
            var color: Color
            switch self {
            case .success:
                color = Theme.current.success2.color
            case .failure:
                color = Theme.current.error19.color
            }
            return color
        }

        var boldColor: Color {
            var color: Color
            switch self {
            case .success:
                color = Theme.current.success3.color
            case .failure:
                color = Theme.current.error18.color
            }
            return color
        }

        var image: Image {
            var img: UIImage
            switch self {
            case .success:
                img = ImageAssets.roundedCheckMark.image
            case .failure:
                img = ImageAssets.alert.image
            }
            return Image(uiImage: img)
        }
    }
}

// MARK: - Image assets

extension ToastView {
    enum ImageAssets: String, ImageLoader {
        case closeSolid
        case alert
        case roundedCheckMark
    }
}

// MARK: - Automation Ids

extension ToastView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case titleLabel
        case toastStateImageView
        case toastDescriptionLabel
        case closeButton
    }
}
