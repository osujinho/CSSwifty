//
//  PublicModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/17/21.
//

import SwiftUI

// Intro View for all Problems
struct IntroView: View {
    
    let title: String
    let bullet = "• "
    let summarys: [String]
    
    var body: some View {
        VStack{
            Text(title)
                .font(.headline)
            ForEach(summarys, id: \.self) { summary in
                HStack(alignment: .firstTextBaseline) {
                    Text(bullet)
                        .font(.headline)
                    Text(summary)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .containerViewModifier(fontColor: .white, borderColor: .black)
    }
}

// Image view for all problems
struct ImageAndRuleView: View {
    let imageName: String
    let bullet = "• "
    let rules: [String]
    
    var body: some View {
        HStack(alignment: .top){
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            VStack {
                Text("Rules")
                    .font(.headline)
                ForEach(rules, id:\.self) { rule in
                    HStack(alignment: .firstTextBaseline) {
                        Text(bullet)
                            .font(.headline)
                        Text(rule)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .containerViewModifier(fontColor: .white, borderColor: .black)
    }
}

// Text Editor with character count
struct TextEditorView: View {
    @Binding var text: String
    @Binding var characters: String
    let charCount: Func
    let charTotal: Int
    let label: String
    
    init(text: Binding<String>, characters: Binding<String>, charCount: @escaping Func, charTotal: Int, label: String) {
        UITextView.appearance().backgroundColor = .clear
        self._text = text
        self._characters = characters
        self.charCount = charCount
        self.charTotal = charTotal
        self.label = label
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            TextEditor(text: $text)
                .onChange(of: text, perform: { _ in
                    charCount()
                })
                .padding()
                .background(Color.yellow.opacity(0.5))
                .foregroundColor(Color.white)
                .font(Font.custom("AvenirNext-Regular", size: 14, relativeTo: .body))
                .cornerRadius(25)
            ProgressView("Characters: \(characters) / \(charTotal)", value: Double(characters), total: Double(charTotal))
                .font(.caption2)
                .padding(.horizontal, 20)
                .accentColor(.yellow)
        }
    }
}

struct ClearOrSubmitButton: View {
    let icon: String
    let buttonAction: Func
    let isDisabled: Bool
    let bgColor: Color
    
    var body: some View {
        Button(action: {
            buttonAction()
        }, label: {
            HStack {
                Image(systemName: icon)
            }
            .font(Font.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            .background(bgColor.cornerRadius(40))
            .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke((Color.white), lineWidth: 1))
            .opacity(isDisabled ? 0.5 : 1.0)
        }).disabled(isDisabled)
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
            .padding(10)
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

// Modifier for a delete and Submit button
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
