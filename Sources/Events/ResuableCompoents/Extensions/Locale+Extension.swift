//
//  Locale+Extension.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation

typealias LocaleInfo = (language: String, region: String)

extension Locale {
    enum Constants: String {
        case en_us = "en-us"
        case zh_tw = "zh-tw"
    }

    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }

    static func mergedLocale() -> String {
        let locale = localeInfo()
        if locale.language == "zh" {
            return Constants.zh_tw.rawValue
        } else {
            return Constants.en_us.rawValue
        }
    }

    static func localeInfo() -> LocaleInfo {
        if let languageCode = preferredLocale().languageCode?.lowercased(),
           let regionCode = preferredLocale().regionCode?.lowercased()
        {
            return (language: languageCode, region: regionCode)
        }
        return (language: "en", region: "us")
    }

    static func getLanguageCode() -> String {
        preferredLocale().languageCode?.lowercased() ?? "en"
    }
}
