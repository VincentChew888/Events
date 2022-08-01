//
//  Dictionary+Extensions.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import Foundation

extension Dictionary where Key == String {
    func lowercaseValues() -> [String: Any] {
        mapValues { value in
            if let strVal = value as? String {
                return strVal.lowercased()
            } else {
                return value
            }
        }
    }
}
