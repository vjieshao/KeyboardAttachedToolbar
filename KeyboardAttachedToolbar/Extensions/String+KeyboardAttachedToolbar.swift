//
//  String+KeyboardAttachedToolbar.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/5/7.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

extension String {

    public func substring(from: Int, to: Int) -> String {

        if (to - from) < 0 {
            return ""
        }

        let start = self.utf16.index(self.startIndex, offsetBy: from)
        let end = self.utf16.index(start, offsetBy: min(to - from, self.utf16.count))
        return String(self[start..<end])
    }

    public func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }

    public func slice(from start: String, to: String) -> String? {

        if start.isEmpty {
            return (self.range(of: to, range: self.startIndex..<self.endIndex)?.lowerBound).map { eInd in
                String(self[self.startIndex..<eInd])
            }
        }

        return (self.range(of: start)?.upperBound).flatMap { sInd -> String? in
            (self.range(of: to, range: sInd..<self.endIndex)?.lowerBound).map { eInd in
                String(self[sInd..<eInd])
            }
        }
    }

    public func rangeFromNSRange(range: NSRange) -> Range<String.Index>? {
        guard let from = self.utf16.index(self.utf16.startIndex, offsetBy: range.location, limitedBy: self.utf16.endIndex) else { return nil }
        guard let to = self.utf16.index(from, offsetBy: range.length, limitedBy: self.utf16.endIndex) else { return nil }
        return from ..< to
    }
}
