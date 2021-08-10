//
//  CreditCardModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/9/21.
//

import Foundation

enum CreditCard: CaseIterable {
    case visa
    case masterCard
    case maestro13
    case maetro15
    case maestro16
    case americanExpress
    case dinersClub
    case discovery
    case jcb15
    case jcb16
    
    
    var name: String {
        switch self {
        case .visa: return "VISA"
        case .masterCard: return "MasterCard"
        case .maestro13, .maetro15, .maestro16: return "Maestro"
        case .americanExpress: return "American Express"
        case .dinersClub: return "Diners Club"
        case .discovery: return "Discovery"
        case .jcb15, .jcb16: return "JCB"
        }
    }
    
    var prefix: Set<String> {
        switch self {
        case .visa: return ["40", "41", "42", "43", "44", "45", "46", "47", "48", "49"]
        case .masterCard: return ["51", "52", "53", "54", "55", "22", "23", "24", "25", "26", "27"]
        case .maestro13: return ["50"]
        case .maetro15: return ["56", "57", "58"]
        case .maestro16: return ["61", "63", "67", "68", "69"]
        case .americanExpress: return ["34", "37"]
        case .dinersClub: return ["30", "36", "38", "39"]
        case .discovery: return ["60", "62", "64", "65"]
        case .jcb15: return ["21", "18"]
        case .jcb16: return ["35"]
        }
    }
    
    var cardImage: String {
        switch self {
        case .visa: return "visa"
        case .masterCard: return "mastercard"
        case .maestro13, .maetro15, .maestro16: return "maestro"
        case .americanExpress: return "amex"
        case .dinersClub: return "diners"
        case .discovery: return "discovery"
        case .jcb15, .jcb16: return "jcb"
        }
    }
    
    var cardMask: String {
        switch self {
        case .visa, .masterCard, .maestro16, .discovery, .jcb16: return "XXXX XXXX XXXX XXXX"
        case .maestro13: return "XXXX XXXX XXXXX"
        case .maetro15, .americanExpress, .jcb15: return "XXXX XXXXXX XXXXX"
        case .dinersClub: return "XXXX XXXXXX XXXX"
        }
    }
    
    var cardLength: Int {
        switch self {
        case .visa, .masterCard, .maestro16, .discovery, .jcb16: return 16
        case .maestro13: return 13
        case .maetro15, .americanExpress, .jcb15: return 15
        case .dinersClub: return 14
        }
    }
    
}


// Extension to format the Card Number input
extension String {
    func cardFormat() -> String {
        let mask = CreditCard.allCases.first(where: { $0.prefix.contains(String(self.prefix(2))) })? .cardMask ?? "XXXX XXXX XXXX XXXX XXX"
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
