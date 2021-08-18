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
                
                InputView(outputType: $model.outputType, key: $model.key)
                
                CiperOutput(cipher: model.outputText, option: model.outputType)
                
                TextEditorView(text: $model.inputText, characters: $model.characterCount, clearFunc: model.clear, submitFunc: model.newCipherText, charCount: model.totalCharacter, charTotal: model.maximumCharacters, label: model.textEditorLabel())
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
