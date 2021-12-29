//
//  PublicExtensions.swift
//  CSSwifty
//
//  Created by Michael Osuji on 9/1/21.
//

import SwiftUI

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

// To set a minimum and maximum value for a comparable value
extension Comparable {
    func clamp(minimum: Self, maximum: Self) -> Self {
        if self < minimum { return minimum }
        if self > maximum { return maximum }
        return self
    }
}

// extension to calculate the average of an array
extension Array where Element: BinaryInteger {
    var average: Int {
        if self.isEmpty {
            return 0
        } else {
            let sum = self.reduce(0, +)
            return Int(round( Double(sum) / Double(self.count) ))
        }
    }
}

// Resize an image
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
