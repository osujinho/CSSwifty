//
//  ProblemTwoModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/17/21.
//

import SwiftUI

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

// -----------------------------FOR CAESAR ----------------------------
struct InputView: View {
    @Binding var outputType: TextOption
    @Binding var key: UInt8
    
    init(outputType: Binding<TextOption>, key: Binding<UInt8>) {
        self._outputType = outputType
        self._key = key
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemGreen
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        HStack {
            HStack {
                Text("Option")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Picker("Text option", selection: $outputType) {
                    ForEach(TextOption.allCases) { type in
                        HStack {
                            Text(type.name)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Spacer()
            
            NumericStepper(key: $key)
            
        }.containerViewModifier(fontColor: .white, borderColor: .black)
    }
}

// -----Custom stepper for input
struct NumericStepper: View {
    @Binding var key: UInt8
    @State var decreasePressed = false
    @State var increasePressed = false
    
    var body: some View {
        HStack{
            Text("Key")
                .font(.subheadline)
                .fontWeight(.semibold)
            Button(action: {
                if key == 0 {
                    return
                } else {
                    key -= 1
                    self.decreasePressed.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        // Bring's sender's opacity back up to fully opaque
                        self.decreasePressed = false
                    }
                }
            }) {
                Image(systemName: "chevron.left")
            }
            .disabled(key <= 0)
            .foregroundColor(decreasePressed ? .red : .yellow)
            .opacity(key <= 0 ? 0.5 : 1.0)
            
            Text("\(key)")
                .foregroundColor(fontColor())
            
            Button(action: {
                if key == 26 {
                    return
                } else {
                    key += 1
                    self.increasePressed.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        // Bring's sender's opacity back up to fully opaque
                        self.increasePressed = false
                    }
                }
            }) {
                Image(systemName: "chevron.right")
            }
            .disabled(key >= 26)
            .foregroundColor(increasePressed ? .green : .yellow)
            .opacity(key >= 26 ? 0.5 : 1.0)
        }
        .padding(10)
    }
    
    // Changes color of number when increased or decreased.
    func fontColor() -> Color {
        if increasePressed {
            return Color.green
        } else if decreasePressed {
            return Color.red
        } else {
            return Color.white
        }
    }
}

// ------------------------Cipher text Output--------------------------
struct CiperOutput: View {
    let cipher: String
    let option: TextOption
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(option == .encrypt ? "CipherText" : "PlainText")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(cipher)
                .foregroundColor(.yellow)
        }
        .padding(10)
        .coinStackModifier(bgColor: .clear, lineColor: .black)
    }
}
