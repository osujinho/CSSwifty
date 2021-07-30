//
//  ProblemViewModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/21/21.
//

import SwiftUI

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
                    .padding(.bottom, 5)
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


