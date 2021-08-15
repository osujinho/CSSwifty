//
//  MarioMore.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

struct MarioMore: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = MarioMoreViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Introduction", summarys: model.intro)
                
                ImageAndRuleView(imageName: "Mario-More", rules: model.rules)
                
                Stepper(value: $model.selectedHeight, in: 0...8, step: 1) {
                    HStack {
                        Text("Pyramid Height:")
                        Text("\(model.selectedHeight)")
                            .foregroundColor(.blue)
                    }
                }
                .containerViewModifier(fontColor: .white, borderColor: .black)
                
                PyramidBoard(imageName: "MarioBg", texts: model.drawPyramid(), pyramidAlignment: .bottom)
                
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
