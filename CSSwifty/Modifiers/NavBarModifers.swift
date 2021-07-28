//
//  Interfaces.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/29/21.
//

import SwiftUI
import UIKit

//--------------- Navigation bar customization Modifier --------------------------------
struct NavigationBarModifier: ViewModifier {
    var titleColor: UIColor?
    var firstGradientColor: Color
    var secondGradientColor: Color
    
    init(titleColor: UIColor?, firstGradientColor: Color, secondGradientColor: Color) {
        self.firstGradientColor = firstGradientColor
        self.secondGradientColor = secondGradientColor
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    LinearGradient(gradient: Gradient(colors: [firstGradientColor, secondGradientColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarModifier(titleColor: UIColor?, firstGradientColor: Color, secondGradientColor: Color) -> some View {
        self.modifier(NavigationBarModifier(titleColor: titleColor, firstGradientColor: firstGradientColor, secondGradientColor: secondGradientColor))
    }
}

// View Modifier for the SubView Navigation Bars
struct SubViewNavigationBar: ViewModifier {
    var title: String
    var titleColor: Color
    var fontSize: CGFloat
    var presentationMode: Binding<PresentationMode>
    var buttonColor: Color
    
    init(title: String, titleColor: Color, fontSize: CGFloat, presentationMode: Binding<PresentationMode>, buttonColor: Color) {
        self.title = title
        self.titleColor = titleColor
        self.fontSize = fontSize
        self.presentationMode = presentationMode
        self.buttonColor = buttonColor
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(buttonColor)
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: fontSize))
                        .fontWeight(.heavy)
                        .foregroundColor(titleColor)
                }
            }
    }
}

extension View {
    func subViewNavigationBar(title: String, titleColor: Color, fontSize: CGFloat, presentationMode: Binding<PresentationMode>, buttonColor: Color) -> some View {
        self.modifier(SubViewNavigationBar(title: title, titleColor: titleColor, fontSize: fontSize, presentationMode: presentationMode, buttonColor: buttonColor))
    }
}

