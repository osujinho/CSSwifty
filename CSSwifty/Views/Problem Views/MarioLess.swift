//
//  MarioLess.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

struct MarioLess: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = MarioLessViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Introduction", summarys: model.intro)
                
                ImageAndRuleView(imageName: "Mario-Less", rules: model.rules)
                
                Stepper(value: $model.selectedHeight, in: 0...8, step: 1) {
                    HStack {
                        Text("Pyramid Height:")
                        Text("\(model.selectedHeight)")
                            .foregroundColor(.blue)
                    }
                }
                .containerViewModifier(fontColor: .white, borderColor: .black)
                
                PyramidBoard(imageName: "MarioBg", texts: model.drawPyramid(), pyramidAlignment: .bottomTrailing)
                
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: "Mario Less", titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}

