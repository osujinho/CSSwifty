//
//  Substitution.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Substitution: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = SubstitutionViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                IntroView(title: "Substitution Cipher", summarys: model.intro)
                
                ImageAndRuleView(imageName:  model.problem.image, rules: model.rules)
                
                OptionPicker(outputType: $model.outputType).containerViewModifier(fontColor: .white, borderColor: .black)
                
                KeyInput(key: $model.key, onChangeFunc: model.validateKey)
                
                CipherOutput(cipher: model.outputText, option: model.outputType)
                
                HStack {
                    TextEditorView(text: $model.inputText, characters: $model.characterCount, charCount: model.totalCharacter, charTotal: model.maximumCharacters, label: model.textEditorLabel())
                    VStack {
                        ClearOrSubmitButton(icon: "xmark", buttonAction: model.clear, isDisabled: model.key.count < 26 && model.inputText.isEmpty, bgColor: .red)
                        Spacer()
                        ClearOrSubmitButton(icon: "return", buttonAction: model.modifiedText, isDisabled: model.key.count < 26 && model.inputText.isEmpty, bgColor: .green)
                    }
                }
                .containerViewModifier(fontColor: .white, borderColor: .black)
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
