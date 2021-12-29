//
//  KeypadModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/30/21.
//

import SwiftUI

struct KeyPadbuttonModifier: ViewModifier {
    let fontColor: Color
    let bgColor: Color
    let borderColor: Color
    let opacityValue: Double
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 20, weight: .semibold))
            .foregroundColor(fontColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(bgColor.cornerRadius(40))
            .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke((borderColor), lineWidth: 1))
            .opacity(opacityValue)
    }
}

extension View {
    func keyPadButtonModifier(fontColor: Color, bgColor: Color, borderColor: Color, opacityValue: Double) -> some View {
        self.modifier(KeyPadbuttonModifier(fontColor: fontColor, bgColor: bgColor, borderColor: borderColor, opacityValue: opacityValue))
    }
}
