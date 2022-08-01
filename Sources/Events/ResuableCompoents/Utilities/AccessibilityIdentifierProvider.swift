//
//  AccessibilityIdentifierProvider.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import Foundation

/// Identifier provider for automation control
protocol AccessibilityIdentifierProvider {
    func accessibilityIdentifier(suffix: String?) -> String
}

extension AccessibilityIdentifierProvider where Self: RawRepresentable, Self.RawValue == String {
    func accessibilityIdentifier(suffix: String? = nil) -> String {
        guard let suffix = suffix else { return rawValue }
        return "\(rawValue)-\(suffix)"
    }
}
