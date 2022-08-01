//
//  String+Extension.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import UIKit

extension String {
    /// email validation with regular expression
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    var isNotEmpty: Bool {
        !isEmpty
    }

    var trimWhitespacesAndNewlines: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var toURL: URL? {
        URL(string: self)
    }

    var removingHTMLTags: String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    var trimSpecialCharacters: String {
        let filteredCharacters = filter {
            String($0).rangeOfCharacter(from: NSCharacterSet.alphanumerics) != nil
        }
        return String(filteredCharacters)
    }

    /// Variable to remove extra backslack that gets added due to below reason
    /// - Reason: When you save a text with \n in local database using coredata or sqlite. It automatically set another backslash additionally
    /// - Reference: https://stackoverflow.com/questions/35053698/newline-n-not-working-in-swift/40234710
    var addNewLineAfterDataOperations: String {
        replacingOccurrences(of: "\\n", with: "\n")
    }

    /// Method to return the bounding box size that is occupied by the text with the given font.
    /// - Parameter font: The font of the text.
    /// - Returns: The bounding box size.

    func boundingBox(font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let value = self
        return value.size(withAttributes: attributes)
    }

    func htmlToAttributedString(font: UIFont?,
                                lineHeight: CGFloat = 21,
                                alignment: NSTextAlignment = .left) -> NSAttributedString?
    {
        guard let font = font else { return nil }
        let modifiedFont = NSString(format: "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize)\">%@</span>" as NSString, self)
        guard let data = modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                                                 documentAttributes: nil)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.alignment = alignment
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            return attributedString
        } catch {
            return nil
        }
    }

    /// Method to generate a final query from given list of parameters
    /// - Parameter parametersDict: Dictionary of Parameters with key and values as string.
    /// - Returns: final query in form of string.
    func queryString(with parametersDict: [String: String]) -> String {
        var data = [String]()
        for (key, value) in parametersDict {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    static func constructIndexTitles() -> [String] {
        var uniLetters = (65 ..< (65 + 26)).map { String(UnicodeScalar($0)) }
        uniLetters.append("#")
        return uniLetters
    }

    func encodedURL() -> URL? {
        let reqUrl = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let encodedURL = reqUrl,
              let url = URL(string: encodedURL) else { return nil }
        return url
    }
}

// MARK: - Date

extension String {
    /// Converts string api date  to loclalised date according to time zone of the device.
    /// - UseCase: - November 1  2021, 18:30 pm UTC time after localization  should get converted to November 2 2021 12:00 am  according to indian time zone [+5:30 Hours from GMT]"
    /// - Descrption: - Internally uses ISODateFormatter to perform localization
    /// - Parameter: - pass the format in which date is required - default is long format: "yyyy MMM dd, hh:mm a"
    func localizedDateString(using format: String = DateFormat.longFormat) -> String {
        guard let isoDate = DateFormatter.toDate(using: self) else {
            return ""
        }
        Date.dateFormatter.dateFormat = format
        return Date.dateFormatter.string(from: isoDate)
    }

    func defaultLocalizedDateStringWithLocaleWithISOFormat(using format: String = DateFormat.longFormat) -> String {
        guard let isoDate = DateFormatter.toDate(using: self) else {
            return ""
        }
        Date.dateFormatterLocalized.setLocalizedDateFormatFromTemplate(format)
        return Date.dateFormatterLocalized.string(from: isoDate)
    }

    func isoDate() -> Date? {
        guard let isoDate = DateFormatter.toDate(using: self) else {
            return nil
        }
        return isoDate
    }

    func nonLocalizedDate(using format: String) -> Date? {
        Date.dateFormatter.dateFormat = format
        return Date.dateFormatter.date(from: self)
    }
}

// MARK: - URL

extension String {
    var isAValidURL: Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector?.firstMatch(in: self, options: [],
                                            range: NSRange(location: 0, length: utf16.count))
        {
            // it is a link, if the match covers the whole string
            return match.range.length == utf16.count
        } else {
            return false
        }
    }
}

extension String {
    func load() -> UIImage {
        do {
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            return UIImage()
        }
    }
}

extension String {
    func heightForView(font: UIFont, width: CGFloat, lineSpacing: CGFloat = 0) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        if lineSpacing > 0.0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = .center
            label.attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: style])
        } else {
            label.text = self
        }
        label.sizeToFit()
        return label.frame.height
    }
}
