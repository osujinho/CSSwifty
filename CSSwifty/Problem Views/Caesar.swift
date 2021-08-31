//
//  Caesar.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Caesar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = CaesarViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                IntroView(title: "Caesar Cipher", summarys: model.intro)
                
                ImageAndRuleView(imageName:  model.problem.image, rules: model.rules)
                
                HStack {
                    OptionPicker(outputType: $model.outputType)
                    Spacer()
                    NumericStepper(key: $model.key, maxValue: 26, label: "Key")
                }.containerViewModifier(fontColor: .white, borderColor: .black)
                
                CipherOutput(cipher: model.outputText, option: model.outputType)
                
                HStack {
                    TextEditorView(
                        text: $model.inputText,
                        characters: $model.characterCount,
                        charCount: model.totalCharacter,
                        charTotal: model.maximumCharacters,
                        label: model.textEditorLabel())
                    
                    VStack {
                        ClearOrSubmitButton(
                            icon: "xmark",
                            buttonAction: model.clear,
                            isDisabled: model.inputText.isEmpty,
                            bgColor: .red,
                            paddingValue: 10)
                        Spacer()
                        ClearOrSubmitButton(
                            icon: "return",
                            buttonAction: model.newCipherText,
                            isDisabled: model.inputText.isEmpty,
                            bgColor: .green,
                            paddingValue: 10)
                    }
                }.containerViewModifier(fontColor: .white, borderColor: .black)
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
