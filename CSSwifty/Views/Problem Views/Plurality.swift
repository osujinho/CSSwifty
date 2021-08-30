//
//  Plurality.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Plurality: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var model = PluralityViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                IntroView(title: "Plurality Vote", summarys: model.intro)
                
                ImageAndRuleView(imageName:  model.problem.image, rules: model.rules)
                
                VStack{
                    switch model.electionScreen {
                    case .addCandidate:
                        VStack {
                            HStack {
                                TextFieldInput(target: $model.nameOfCandidate, label: "Add Candidate", placeHolder: "Name of candidate", onChangeFunc: model.filterCandidateName)
                                
                                // Delete button to remove all candidates
                                Button(action: {model.candidates.removeAll()}, label: {})
                                    .buttonStyle(IconButtonStyle(iconName: "trash", iconColor: .red))
                                    .opacity(model.candidates.isEmpty ? 0.5 : 1.0)
                                    .disabled(model.candidates.isEmpty)
                            }
                            .padding(.bottom, 10)
                            
                            AddCandidate(candidates: $model.candidates, addCandidate: model.addCandidates, addStatus: model.addStatus, candidateName: model.nameOfCandidate, updateMenu: model.switchToNumberOfVoterScreen, opacityValue: model.validIconOpacity)
                        }
                    case .numberOfVoter:
                        NumberOfVoters(numberOfVoters: $model.numberOfVoters, switchScreen: model.switchScreen(screen:), previousScreen: .addCandidate, nextScreen: .votingBooth)
                    case .votingBooth: VotingBooth()
                    case .winner: WinnerView()
                    }
                }.containerViewModifier(fontColor: .white, borderColor: .black)
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
        .environmentObject(model)
    }
}
