//
//  PublicExtensions.swift
//  CSSwifty
//
//  Created by Michael Osuji on 9/1/21.
//

import Foundation

// Extension to convert an Integer to an ordinal number
// Ordinal numbers are 1st, 2nd, 3rd, 4th etc
extension Int {   // call it using 1.ordinal = 1st
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

// An Array extension to make combinations
extension Array {
    // returns all combinations possible with the given array
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
    
    // returns desired combinations with the given length
    func combination(length: Int) -> [[Element]]{
        self.combinationsWithoutRepetition.filter { $0.count == length }
    }
}
