//
//  Cash.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

struct Cash: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = CashViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Greddy Algorithms", summarys: model.intro)
                
                ImageAndRuleView(imageName: "Cash", rules: model.rules)
                
                
                VStack(alignment: .leading, spacing: 1) {
                    Coin(coinName: "Pennies", coinAmount: model.pennies, borderColor: .black)
                    Coin(coinName: "Nickels", coinAmount: model.nickels, borderColor: .black)
                    Coin(coinName: "Dimes", coinAmount: model.dimes, borderColor: .black)
                    Coin(coinName: "Quaters", coinAmount: model.quaters, borderColor: .black)
                    Coin(coinName: "Total Coins", coinAmount: model.totalCoins, borderColor: .blue)
                }
                .coinStackModifier(bgColor: .clear, lineColor: .black)
                
                Amount(amount: model.changeString, calcChange: model.calculateChange, clearAmount: model.clearAmount)
                    .coinStackModifier(bgColor: .clear, lineColor: .black)
                
                KeypadView(amount: $model.changeString, hasDecimal: true, maxDigits: 4)
                
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: "Cash", titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
