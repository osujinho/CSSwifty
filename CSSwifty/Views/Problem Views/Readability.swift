//
//  Readability.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Readability: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = ReadabilityViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                IntroView(title: "Coleman-Liau index", summarys: model.intro)
                
                ImageAndRuleView(imageName:  model.problem.image, rules: model.rules)
                
                AnalysisView(sentenceCount: model.sentenceCount, wordCount: model.wordCount, characterCount: model.characterCount, grade: model.grade.name)
                
                HStack {
                    TextEditorView(text: $model.text, characters: $model.characterCount, charCount: model.totalCharacters, charTotal: 500, label: "Enter your text:")
                    VStack {
                        ClearOrSubmitButton(icon: "xmark", buttonAction: model.clear, isDisabled: model.text.isEmpty, bgColor: .red, paddingValue: 10)
                        Spacer()
                        ClearOrSubmitButton(icon: "return", buttonAction: model.submit, isDisabled: model.text.isEmpty, bgColor: .green, paddingValue: 10)
                    }
                }.containerViewModifier(fontColor: .white, borderColor: .black)
                
                
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}

