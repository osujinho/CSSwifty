//
//  Credit.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

struct Credit: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = CreditViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Luhn's Algorithms", summarys: model.intro)
                
                ImageAndRuleView(imageName: "Credit", rules: model.rules)
                
                CardImage(cardName: model.getCardInfo()?.name ?? "Unidentified", imageName: model.getCardInfo()?.cardImage ?? "invalidcard", cardValidity: model.cardValidity, reset: model.resetCard)
                
                CardNumber(cardNumber: model.cardNumber, validateCard: model.validateCard, imageName: model.getCardInfo()?.cardImage ?? "Invalid")
                
                KeypadView(amount: $model.cardNumber, hasDecimal: false, maxDigits: model.getCardInfo()?.cardLength ?? 19, submitFunction: model.validateCard)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}

