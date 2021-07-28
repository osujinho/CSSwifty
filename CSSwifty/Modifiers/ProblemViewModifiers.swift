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
    let backgroundColor: Color
    let borderColor: Color
    
    var body: some View {
        VStack{
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
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
        .containerViewModifier()
    }
}

struct ImageAndRuleView: View {
    let imageName: String
    let bullet = "• "
    let rules: [String]
    let backgroundColor: Color
    
    var body: some View {
        HStack{
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
            .background(backgroundColor)
        }
        .containerViewModifier()
    }
}

struct PyramidBoard: View {
    let imageName: String
    let texts: String
    let pyramidAlignment: Alignment
    
    var body: some View {
        ZStack(alignment: pyramidAlignment) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text(texts)
                .font(.system(.title3, design: .monospaced).leading(.tight))
                .foregroundColor(pyramidColor)
                .padding(.horizontal, 10)
                .offset(x: 0, y: -10)
        }
        .containerViewModifier()
    }
}

struct ContainerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding(5)
            .background(Color.white.cornerRadius(10))
            .padding(5)
            .background(Color.black.cornerRadius(10))
            .padding(.horizontal, 15)
    }
}

extension View {
    func containerViewModifier() -> some View {
        self.modifier(ContainerViewModifier())
    }
}
