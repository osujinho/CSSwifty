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
            LinearGradient(gradient: Gradient(colors: [marioMoreFirstColor, marioMoreSecondColor]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Introduction", summarys: model.intro, backgroundColor: .white, borderColor: .black)
                
                ImageAndRuleView(imageName: "Mario-More", rules: model.rules, backgroundColor: .white)
                
                Stepper(value: $model.selectedHeight, in: 0...8, step: 1) {
                    HStack {
                        Text("Pyramid Height:")
                        Text("\(model.selectedHeight)")
                            .foregroundColor(.blue)
                    }
                }
                .containerViewModifier()
                
                PyramidBoard(imageName: "MarioBg", texts: model.drawPyramid(), pyramidAlignment: .bottom)
                
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: "Mario More", titleColor: .white, fontSize: 30, presentationMode: presentationMode, buttonColor: .white)
    }
}
