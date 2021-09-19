//
//  PublicExtensions.swift
//  CSSwifty
//
//  Created by Michael Osuji on 9/1/21.
//

import Foundation

// Extension to convert an Integer to an ordinal number
// Ordinal numbers are 1st, 2nd, 3rd, 4th etc
extension Int {
    var toOrdinal: String {
        get {
            var suffix = "th"
            switch self % 10 {
                case 1:
                    suffix = "st"
                case 2:
                    suffix = "nd"
                case 3:
                    suffix = "rd"
                default: ()
            }
            if 10 < (self % 100) && (self % 100) < 20 {
                suffix = "th"
            }
            return String(self) + suffix
        }
    }
}

// call it using 1.ordinal = 1st
