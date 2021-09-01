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
                        AddCandidate(
                            candidates: $model.candidates,
                            candidateName: $model.nameOfCandidate,
                            addCandidate: model.addCandidates,
                            nameFilter: model.filterCandidateName,
                            addStatus: model.addStatus,
                            updateMenu: model.addCandidatesToMenu,
                            opacityValue: model.validIconOpacity)
                    case .numberOfVoter:
                        NumberOfVoters(numberOfVoters: $model.numberOfVoters, screen: $model.electionScreen)
                    case .votingBooth:
                        VotingBooth(
                            selectedCandidate: $model.candidateVotingFor,
                            voterName: $model.voterName,
                            screen: $model.electionScreen,
                            doneVoting: $model.doneVoting,
                            currentVoter: model.currentVoterNumber,
                            totalVoters: model.numberOfVoters,
                            filterName: model.filterVoterName,
                            candidateChoices: model.candidatesMenu,
                            candidateVotedFor: model.candidateVotedFor(),
                            buttonLabel: "Vote",
                            buttonColor: .green,
                            declareWinner: model.declareWinner,
                            submitVote: model.submitVote)
                    case .winner:
                        WinnerView(winners: model.winners, winningVoteCount: model.winningVoteCount, resetAction: model.resetElection)
                    }
                }.containerViewModifier(fontColor: .white, borderColor: .black)
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
        .environmentObject(model)
    }
}
