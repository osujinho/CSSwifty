//
//  CreditViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/9/21.
//

import Foundation

class CreditViewModel: ObservableObject {
    @Published var cardNumber = ""
    @Published var cardValidity: ValidStatus = ValidStatus.none
    let intro = [
        "A credit (or debit) card, is a means of payment for goods and services.",
        "Every card has a unique number that has a “checksum” built into them, which enables computers to detect invalid numbers",
        "Most cards use Luhn’s algorithm, to determine if a card number is (syntactically) valid."
    ]
    let rules = [
        "Major Credit cards",
        "ONLY Numbers 0-9"
    ]
    let problem: Problems = .credit
    
    func validateCard() {
        var doubleOddDigits = [Int]()
        var sumOfDoubleOddDigits = [Int]()
        var totalOdds: Int
        var totalEvens: Int
        var grandTotal: Int
        
        doubleOddDigits = evenAndOdd(cardNumber: cardNumber).odd.map { $0 * 2}
        for doubleOdd in doubleOddDigits {
            let sumOfDouble = String(doubleOdd).compactMap { $0.wholeNumberValue }.reduce(0, +)
            sumOfDoubleOddDigits.append(sumOfDouble)
        }
        totalOdds = sumOfDoubleOddDigits.reduce(0, +)
        totalEvens = evenAndOdd(cardNumber: cardNumber).even.reduce(0, +)
        grandTotal = totalOdds + totalEvens
        
        if grandTotal % 10 == 0 {
            cardValidity = .valid
        } else {
            cardValidity = .invalid
        }
    }
    
    func evenAndOdd(cardNumber: String) -> (even: [Int], odd: [Int]) {
        let numbers = (cardNumber.map{ String($0) }).compactMap { Int($0) }
        
        var evenDigits = [Int]()
        var oddDigits = [Int]()
        
        for (index, number) in numbers.reversed().enumerated() {
            if index.isMultiple(of: 2) {
                evenDigits.append(number)
            } else {
                oddDigits.append(number)
            }
        }
        return (evenDigits, oddDigits)
    }
    
    func getCardInfo() -> CreditCard? {
        let prefix = String(cardNumber.prefix(2))
        return CreditCard.allCases.first(where: { $0.prefix.contains(prefix)})
    }
    
    func resetCard() {
        cardNumber = ""
        cardValidity = .none
    }
}
