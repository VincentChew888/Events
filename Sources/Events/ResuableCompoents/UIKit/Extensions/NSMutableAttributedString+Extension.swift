//
//  AttributedString.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import UIKit

extension NSMutableAttributedString {
    /// Returns instance of NSAttributedString with same contents and attributes with line height added.
    /// - Parameters:
    ///   - height: value for height you want to assign to the text.
    ///   - alignment: text alignment
    /// - Returns: instance of NSAttributedString with given line height.
    func lineHeight(_ height: CGFloat, _ alignment: NSTextAlignment = .center) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = height
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.alignment = alignment
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with different font for given text.
    /// - Parameters:
    ///   - text: different dont for text  defaullt will be for entire text
    ///   - font: font
    /// - Returns: instance of NSAttributedString with given font
    func setFont(for text: String? = nil, withFont font: UIFont?) -> NSMutableAttributedString {
        guard let font = font else { return self }
        let range: NSRange = mutableString.range(of: text ?? string, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with different color for given text.
    /// - Parameters:
    ///   - text: text color defaullt will be for entire text
    ///   - color: color
    /// - Returns: instance of NSAttributedString with given color
    func setColor(for text: String? = nil, withColor color: UIColor?) -> NSMutableAttributedString {
        guard let color = color else { return self }

        let range: NSRange = mutableString.range(of: text ?? string, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with letter spacing added.
    /// - Parameter spacing: space between the letters for the given text
    /// - Returns: instance of NSAttributedString with given letter spacing
    func letterSpacing(_ spacing: CGFloat = 1) -> NSMutableAttributedString {
        addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: length))
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with custom font for different texxts in a given string.
    /// - Parameters:
    ///   - texts: list of text for which custom font should be added
    ///   - font: custom font
    /// - Returns: instance of NSAttributedString with given custom font
    func setFont(for texts: [String], withFont font: UIFont?) -> NSMutableAttributedString {
        guard let font = font else { return self }

        texts.forEach { text in
            let range: NSRange = mutableString.range(of: text, options: .caseInsensitive)
            addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with different color for given texts.
    /// - Parameters:
    ///   - texts: list of text for which given color should be changed
    ///   - color: color
    /// - Returns: instance of NSAttributedString with given color
    func setColor(for texts: [String], withColor color: UIColor?) -> NSMutableAttributedString {
        guard let color = color else { return self }

        texts.forEach { text in
            let ranges = string.ranges(of: text, options: .caseInsensitive)
            let allWords = ranges.map { NSRange($0, in: text) }
            allWords.forEach { range in
                addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }
        }
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with link for given string
    /// - Parameters:
    ///   - link: text link
    ///   - range: range
    /// - Returns: instance of NSAttributedString with link
    func addlink(for link: String, range: NSRange?) -> NSMutableAttributedString {
        guard let range = range else { return self }

        addAttribute(.link, value: link, range: range)
        return self
    }

    /// Returns instance of NSAttributedString with same contents and attributes with underlined for given string
    /// - Parameter text: underline text
    /// - Returns: instance of NSAttributedString with underline
    func addUnderline(for text: String? = nil) -> NSMutableAttributedString {
        let range: NSRange = mutableString.range(of: text ?? string, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: range)
        return self
    }

    func addAttachment(image: UIImage,
                       yPadding: CGFloat = 0,
                       size: CGSize = .zero) -> NSMutableAttributedString
    {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0,
                                   y: yPadding,
                                   width: size.width,
                                   height: size.height)
        let attachmentString = NSMutableAttributedString(attachment: attachment)
        append(attachmentString)
        return attachmentString
    }

    static func attributedText(_ text: String, lineHeight: CGFloat, alignment: NSTextAlignment = .left) -> NSAttributedString {
        NSMutableAttributedString(string: text)
            .lineHeight(lineHeight, alignment)
    }
}
