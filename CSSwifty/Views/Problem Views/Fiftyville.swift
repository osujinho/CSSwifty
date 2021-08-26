//
//  Fiftyville.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Fiftyville: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var problem = Problems.fiftyville
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text(problem.name)
                        .font(.largeTitle)
                    Text("Is under construction...")
                        .font(.title3)
                    Text("😎")
                }
                .foregroundColor(.white)
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
