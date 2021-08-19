//
//  ProblemOnesModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/17/21.
//

import SwiftUI

// ----------------------------Mario More and Mario less-----------------------

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
    let cardValidity: ValidStatus
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
