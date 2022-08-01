//
//  Bool+Extension.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Foundation

extension Bool {
    static var iOS14: Bool {
        guard #available(iOS 15, *) else {
            // It's iOS 15 so return true.
            return true
        }
        // It's not iOS 14 so return false.
        return false
    }

    static var iOS15AndAbove: Bool {
        guard #available(iOS 15, *) else {
            // It's less than iOS 15 so return false.
            return false
        }
        // It's iOS 15 and above so return true.
        return true
    }
}
