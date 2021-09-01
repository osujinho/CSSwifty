//
//  PublicModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/17/21.
//

import SwiftUI



// Custom icon button without background or padding
struct IconButtonStyle: ButtonStyle {
    let iconName: String
    let iconColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: iconName)
            .font(.title3)
            .foregroundColor(configuration.isPressed ? iconColor.opacity(0.6) : iconColor)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}

// ------------------------------ View Modifiers -------------------------
// Modifier for single textViews showing the coins
struct CoinStackModifier: ViewModifier {
    var bgColor: Color
    var borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(3)
            .background(bgColor.cornerRadius(10).opacity(0.6))
            .padding(2)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke((borderColor), lineWidth: 2.5))
            .shadow(radius: 10)
            .padding(.horizontal, 15)
    }
}

extension View {
    func coinStackModifier(bgColor: Color, lineColor: Color) -> some View {
        self.modifier(CoinStackModifier(bgColor: bgColor, borderColor: lineColor))
    }
}

// Modifier for containers
struct ContainerViewModifier: ViewModifier {
    let fontColor: Color
    let borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(fontColor)
            .font(.system(size: 14))
            .padding(10)
            .background(Color.black.opacity(0.5).cornerRadius(10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke((borderColor), lineWidth: 2)
            )
            .padding(.horizontal, 15)
    }
}

extension View {
    func containerViewModifier(fontColor: Color, borderColor: Color) -> some View {
        self.modifier(ContainerViewModifier(fontColor: fontColor, borderColor: borderColor))
    }
}

// Modifier for a delete and Submit button with icon and label
struct DeleteSubmitButtonModifier: ViewModifier {
    let fontColor: Color
    let bgColor: Color
    let borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 20, weight: .semibold))
            .foregroundColor(fontColor)
            .padding()
            .background(bgColor.cornerRadius(40))
            .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke((borderColor), lineWidth: 1))
    }
}

extension View {
    func deleteSubmitButtonModifier(fontColor: Color, bgColor: Color, borderColor: Color) -> some View {
        self.modifier(DeleteSubmitButtonModifier(fontColor: fontColor, bgColor: bgColor, borderColor: borderColor))
    }
}

// Single button with label no icon
struct SingleButtonModifier: ViewModifier {
    let fontSize: CGFloat
    let bgColor: Color
    let verticalPadding: CGFloat
    let horrizontalPadding: CGFloat
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: fontSize, weight: .semibold))
            .foregroundColor(.white)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horrizontalPadding)
            .background(bgColor.cornerRadius(radius))
            .overlay(RoundedRectangle(cornerRadius: radius)
                        .stroke((Color.white), lineWidth: 1))
    }
}

extension View {
    func singleButtonModifier(fontSize: CGFloat, bgColor: Color, verticalPadding: CGFloat, horizontalPadding: CGFloat, radius: CGFloat) -> some View {
        self.modifier(SingleButtonModifier(fontSize: fontSize, bgColor: bgColor, verticalPadding: verticalPadding, horrizontalPadding: horizontalPadding, radius: radius))
    }
}

// -------------------------- Animations ---------------------------------

// Shake Animation for wrong answer
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 5
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
