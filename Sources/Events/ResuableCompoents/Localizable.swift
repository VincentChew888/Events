//
//  Localizable.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation

// MARK: Localizable

protocol Localizable: RawRepresentable where RawValue == String {
    var localized: String { get }
}

extension Localizable {
    var localized: String {
        rawValue.localized(bundle: .resource)
    }
}

// MARK: String Extension

extension String {
    func localized(bundle: Bundle = .resource) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: self)
    }
}
