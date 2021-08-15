//
//  ProblemViewModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/21/21.
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

// Pyramid image for Mario less and Mario More
struct PyramidBoard: View {
    let imageName: String
    let texts: String
    let pyramidAlignment: Alignment
    let fontColor = Color(red: 203.0 / 255.0, green: 79.0 / 255.0, blue: 15.0 / 255.0)
    
    var body: some View {
        ZStack(alignment: pyramidAlignment) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text(texts)
                .font(.system(.title3, design: .monospaced).leading(.tight))
                .padding(.horizontal, 10)
                .offset(x: 0, y: -10)
        }
        .containerViewModifier(fontColor: fontColor, borderColor: .black)
    }
}

// ---------------------------------FOR CASH ----------------------------
// Coin stack view for Cash
struct Coin: View {
    let coinName: String
    let coinAmount: Int
    let borderColor: Color
    
    var body: some View {
        HStack(alignment: .center) {
            Text(coinName + ": ")
            Spacer()
            Text("\(coinAmount)")
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke((borderColor), lineWidth: 1))
        
    }
}

// Amount View for Cash
struct Amount: View {
    var amount: String
    var calcChange: () -> ()
    var clearAmount: () -> ()
    
    var body: some View {
        HStack {
            Text("Change Owed:")
                .foregroundColor(.white)
            Text(amount.isEmpty ? "0.00" : amount)
                .onChange(of: amount) { _ in
                    calcChange()
                }
                .foregroundColor(amount.isEmpty ? .gray : .white)
            Spacer()
            Button(action: {
                clearAmount()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(amount.isEmpty ? .gray : .red)
                    .opacity(amount.isEmpty ? 0.6 : 1.0)
                    .padding(.horizontal, 10)
            }.disabled(amount.isEmpty)
        }
    }
}

//------------------------ For Credit ----------------------------------------

// ---------To input the card number
struct CardNumber: View {
    let cardNumber: String
    let validateCard: () -> ()
    let imageName: String
    
    var body: some View {
        HStack {
            Text("Card Number:")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .layoutPriority(1)
            Text(cardNumber.cardFormat())
                .foregroundColor(cardNumber.isEmpty ? .gray : .white)
            Spacer()
            if cardNumber.count < 2 {
                EmptyView()
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 20, alignment: .trailing)
                    .padding(.trailing, 5)
            }
        }
        .coinStackModifier(bgColor: .clear, lineColor: .black)
    }
    
}

// - Show the card image --------------
struct CardImage: View {
    let cardName: String
    let imageName: String
    let cardValidity: CardValidity
    let reset: () -> ()
    @State var validAnimationAmount = 1.0
    @State var invalidAnimationAmount = 0.0
    @State var viewOpacity = 1.0
    
    var body: some View {
        if cardValidity == .none {
            EmptyView()
        } else {
            HStack(alignment: .bottom, spacing: 10) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack {
                    Text("The").fontWeight(.bold).foregroundColor(.white)
                    Text(cardName + " card").fontWeight(.bold).foregroundColor(.blue)
                    Text("you entered is...").fontWeight(.bold).foregroundColor(.white)
                    Text(cardValidity.status)
                        .fontWeight(.bold)
                        .foregroundColor(cardValidity == .valid ? .green : .red)
                        .padding(.vertical, 5)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            viewOpacity -= 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            reset()
                        })
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "clear")
                            Text("Reset")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .background(Color.blue.cornerRadius(10))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0)
            )
            .modifier(Shake(animatableData: CGFloat(invalidAnimationAmount)))
            .scaleEffect(CGFloat(validAnimationAmount))
            .opacity(viewOpacity)
            .onAppear {
                if cardValidity == .invalid {
                    withAnimation(.default) {
                        invalidAnimationAmount += 1
                    }
                } else {
                    validAnimationAmount = 0
                    withAnimation(.easeInOut(duration: 2.0)) {
                        validAnimationAmount += 1
                    }
                }
            }
            .onDisappear {
                viewOpacity = 1.0
                invalidAnimationAmount = 0.0
                validAnimationAmount = 1.0
            }
        }
        
    }
}

// -----------------------------FOR READABILITY-----------------------------
struct Analysis: View {
    let label: String
    let display: String
    let borderColor: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
            Spacer()
            Text("\(display)")
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke((borderColor), lineWidth: 1))
    }
}

struct AnalysisView: View {
    let sentenceCount: String
    let wordCount: String
    let characterCount: String
    let grade: String
    
    var body: some View {
        VStack{
            Analysis(label: "Sentence Count:", display: sentenceCount, borderColor: .black)
            Analysis(label: "Word Count:", display: wordCount, borderColor: .black)
            Analysis(label: "Appropriate For:", display: grade, borderColor: .green)
        }.coinStackModifier(bgColor: .clear, lineColor: .black)
    }
}

struct TextEditorView: View {
    @Binding var text: String
    @Binding var characters: String
    let clearFunc: Func
    let submitFunc: Func
    let charCount: Func
    
    let clear: ClearSubmit = .clear
    let submit: ClearSubmit = .submit
    
    init(text: Binding<String>, characters: Binding<String>, clearFunc: @escaping Func, submitFunc: @escaping Func, charCount: @escaping Func) {
        UITextView.appearance().backgroundColor = .clear
        self._text = text
        self._characters = characters
        self.clearFunc = clearFunc
        self.submitFunc = submitFunc
        self.charCount = charCount
    }
    
    var body: some View {
        HStack {
            VStack {
                TextEditor(text: $text)
                    .onChange(of: text, perform: { _ in
                        charCount()
                    })
                    .padding()
                    .background(Color.yellow.opacity(0.5))
                    .foregroundColor(Color.white)
                    .font(Font.custom("AvenirNext-Regular", size: 14, relativeTo: .body))
                    .cornerRadius(25)
                ProgressView("Characters: \(characters) / 500", value: Double(characters), total: 500)
                    .frame(width: 150)
                    .padding(.horizontal, 20)
                    .accentColor(.yellow)
                    .foregroundColor(.white)
            }
            VStack(spacing: 50) {
                Button(action: {
                    clearFunc()
                }, label: {
                    HStack {
                        Image(systemName: clear.icon)
                        //Text(clear.name)
                    }.deleteSubmitButtonModifier(fontColor: .white, bgColor: .red, borderColor: .white)
                    .opacity(text.isEmpty ? 0.5 : 1.0)
                }).disabled(text.isEmpty)
                
                
                
                Button(action: {
                    submitFunc()
                }, label: {
                    HStack {
                        Image(systemName: submit.icon)
                        //Text(submit.name)
                    }.deleteSubmitButtonModifier(fontColor: .white, bgColor: .green, borderColor: .white)
                    .opacity(text.isEmpty ? 0.5 : 1.0)
                }).disabled(text.isEmpty)
            }.foregroundColor(.white)
        }
        .padding(.horizontal, 15)
    }
}

// ------------------------------ View Modifiers -------------------------

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
