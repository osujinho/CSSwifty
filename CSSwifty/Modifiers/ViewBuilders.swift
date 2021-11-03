//
//  ViewBuilders.swift
//  CSSwifty
//
//  Created by Michael Osuji on 9/1/21.
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
            HeadlineLabel(label: label)
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

// ---------- Drop down menu
struct DropDownMenu: View {
    @Binding var selection: String
    @State private var isPressed = false
    
    let collection: Array<String>
    let label: String
    
    let buttonHeight: CGFloat = 30
    let screenHeight = UIScreen.main.bounds.height
    let bgColor = Color(red: 86 / 255, green: 86 / 255, blue: 86 / 255, opacity: 1.0)
    
    
    var body: some View {
        GeometryReader { geometry in
            let verticalLocation = geometry.frame(in: .global).origin.y
            
            VStack {
                Button(action: {
                    isPressed.toggle()
                }) {
                    HStack {
                        Text(selection.isEmpty ? label : selection)
                        Spacer()
                            .frame(width: 30)
                        Image(systemName: isPressed ? "chevron.up" : "chevron.down")
                    }
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                }
                .padding(.horizontal)
                .cornerRadius(10)
                .frame(height: buttonHeight)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1))
                .opacity(selection.isEmpty ? 0.6 : 1.0)
                .overlay(
                    VStack(spacing: 5) {
                        if isPressed {
                            ScrollView {
                                VStack {
                                    Spacer(minLength: buttonHeight - 10)
                                    ForEach(collection, id: \.self) { item in
                                        Button(action: {
                                            selection = item
                                            withAnimation {
                                                isPressed.toggle()
                                            }
                                        }) {
                                            Text(item.capitalized)
                                        }
                                        Divider()
                                            .frame(width: 200)
                                    }
                                }
                                .background(bgColor)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.secondary, lineWidth: 1)
                                )
                            }
                            .frame(height: menuHeight())
                            .offset(y: offsetAmount(location: verticalLocation))
                        }
                    }, alignment: .topLeading
                )
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(bgColor)
                )
            }
            .font(.subheadline)
            .foregroundColor(.yellow)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke((Color.secondary), lineWidth: 1))
        }
        .frame(width: 150, height: 30)
    }
    
    func menuHeight() -> CGFloat {
        let maxHeight = 0.2 * screenHeight
        if collection.count > 5 {
            return maxHeight
        } else {
            return CGFloat((collection.count % 6) + 1) * buttonHeight
        }
    }
    
    func offsetAmount(location: CGFloat) -> CGFloat {
        let bottomSpace = screenHeight - (location + (2 * buttonHeight))
        if menuHeight() >= bottomSpace {
            return -(menuHeight() + 10)
        } else {
            return buttonHeight + 10
        }
    }
}

// Container label Texts
struct HeadlineLabel: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.headline)
            .fontWeight(.semibold)
    }
}

// Delete or Submit button with icon only
struct ClearOrSubmitButton: View {
    let icon: String
    let buttonAction: Func
    let isDisabled: Bool
    let bgColor: Color
    let paddingValue: CGFloat
    
    var body: some View {
        Button(action: {
            buttonAction()
        }, label: {
            HStack {
                Image(systemName: icon)
            }
            .font(Font.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .padding(paddingValue)
            .background(bgColor.cornerRadius(20))
            .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke((Color.white), lineWidth: 1))
            .opacity(isDisabled ? 0.5 : 1.0)
        }).disabled(isDisabled)
    }
}

// Icon only button
struct IconButton: View {
    let icon: String
    let iconColor: Color
    let action: () -> Void
    let isDisabled: Bool
    
    init(icon: String, iconColor: Color, action: @escaping () -> Void, isDisabled: Bool = false) {
        self.icon = icon
        self.iconColor = iconColor
        self.action = action
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: icon)
        }
        .font(.title3)
        .foregroundColor(iconColor)
        .opacity(isDisabled ? 0.6 : 1.0)
        .disabled(isDisabled)
    }
}

// Label only button
struct LabelButton: View {
    let label: String
    let bgColor: Color
    let action: () -> Void
    let isDisabled: Bool
    
    init(label: String, bgColor: Color, action: @escaping () -> Void, isDisabled: Bool = false) {
        self.label = label
        self.bgColor = bgColor
        self.action = action
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(label, action: action)
            .foregroundColor(.white)
            .padding(10)
            .padding(.horizontal, 20)
            .background(bgColor)
            .clipShape(Capsule())
            .opacity(isDisabled ? 0.6 : 1.0)
            .disabled(isDisabled)
    }
}

