//
//  InternetErrorConstants.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

enum InternetErrorConstants {
    static let viewControllerIdentifier = "InternetErrorViewController"
}

enum InternetErrorImageAssets: String, ImageLoader {
    case globe
}

enum InternetErrorText: String, Localizable {
    case internetErrorTitle = "INTERNET_ERROR_TITLE"
    case internetErrorSubtitle = "INTERNET_ERROR_SUBTITLE"
}
