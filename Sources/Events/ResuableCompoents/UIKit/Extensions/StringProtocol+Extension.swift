//
//  StringProtocol+Extension.swift
//  Amway
//
//  Created by Y Media Labs on 14/07/21.
//

import Foundation

extension StringProtocol where Index == String.Index {
    /// Finds and returns the range of the first occurrence of a given string within the string, subject to given options.
    /// - Parameters:
    ///   - string: The string to search for.
    ///   - options: A mask specifying search options. For possible values, see NSString.CompareOptions.
    /// - Returns: An Range structure giving the location and length in the receiver of the first occurrence of string
    func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        var start: Index = startIndex

        while let range = range(of: string, options: options, range: start ..< endIndex) {
            ranges.append(range)
            start = range.upperBound
        }
        return ranges
    }
}
