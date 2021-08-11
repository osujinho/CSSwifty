//
//  CashViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/30/21.
//

import Foundation

class CashViewModel: ObservableObject {
    let intro = [
        "A greedy algorithm always takes the best immediate, or local, solution while finding an answer.",
        "We will use SwiftUI to determine the amount of quarters (25¢), dimes (10¢), nickels (5¢), and pennies (1¢) to give a customer as their change."
    ]
    
    let rules = [
        "US Coins only",
        "ONLY positive integers",
    ]
    
    let problem: Problems = .cash
    
    @Published var changeString = ""
    @Published var pennies = 0
    @Published var nickels = 0
    @Published var dimes = 0
    @Published var quaters = 0
    @Published var totalCoins = 0
    
    func calculateChange() {
        let amountinCent = (Double(changeString) ?? 0) * 100
        
        let amountModQuater = amountinCent.truncatingRemainder(dividingBy: 25)
        let amountModDime = amountModQuater.truncatingRemainder(dividingBy: 10)
        let amountModNickel = amountModDime.truncatingRemainder(dividingBy: 5)
        
        
        
        
        quaters = Int(floor( amountinCent / 25 ))
        self.dimes = Int(floor( amountModQuater / 10 ))
        self.nickels = Int(floor( amountModDime / 5 ))
        self.pennies = Int(floor( amountModNickel / 1 ))
        
        
        self.totalCoins = self.quaters + self.dimes + self.nickels + self.pennies
    }
    
    func clearAmount() {
        self.changeString = ""
    }
}
