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
            HeadlineLabel(label: label)
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
struct OptionPicker: View {
    @Binding var outputType: TextOption
    
    init(outputType: Binding<TextOption>) {
        self._outputType = outputType
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemGreen
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        HStack {
            HeadlineLabel(label: "Option")
            Picker("Text option", selection: $outputType) {
                ForEach(TextOption.allCases) { type in
                    HStack {
                        Text(type.name)
                    }
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

// -----Custom stepper for input
struct NumericStepper: View {
    @Binding var key: Int
    @State var decreasePressed = false
    @State var increasePressed = false
    var maxValue: Int
    var label: String
    
    var body: some View {
        HStack{
            HeadlineLabel(label: label)
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
                if key == maxValue {
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
            .disabled(key >= maxValue)
            .foregroundColor(increasePressed ? .green : .yellow)
            .opacity(key >= maxValue ? 0.5 : 1.0)
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
struct CipherOutput: View {
    let cipher: String
    let option: TextOption
    
    var body: some View {
        VStack(alignment: .leading) {
            HeadlineLabel(label: option == .encrypt ? "CipherText" : "PlainText")
                .foregroundColor(.white)
            Text(cipher)
                .foregroundColor(.yellow)
        }
        .padding(10)
        .coinStackModifier(bgColor: .clear, lineColor: .black)
    }
}

// ------------------------ SUBSTITUTION ---------------------------------------------
// textfield for entering the key with a clear button inside the textField
struct TextFieldInput: View {
    @Binding var target: String
    let label: String
    let placeHolder: String
    let onChangeFunc: Func
    
    var body: some View {
        HStack {
            HeadlineLabel(label: label + ":")
            ZStack(alignment: .trailing) {
                TextField(placeHolder, text: $target)
                    .onChange(of: target) { _ in
                        onChangeFunc()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
                    .font(.subheadline)
                if !target.isEmpty {
                    Button(action: {
                        target = ""
                    }, label: {
                        Image(systemName: "clear")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }).padding(.trailing, 8)
                }
            }
        }
    }
}
