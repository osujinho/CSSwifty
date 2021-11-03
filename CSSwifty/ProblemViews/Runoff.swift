//
//  Runoff.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Runoff: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var model = RunoffViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Runoff Election", summarys: model.intro)
                
                ImageAndRuleView(imageName:  model.problem.image, rules: model.rules)
                
                VStack{
                    switch model.electionScreen {
                    case .addCandidate:
                        AddCandidate(
                            candidates: $model.candidates,
                            candidateName: $model.candidateName,
                            addStatus: $model.addStatus,
                            screen: $model.electionScreen,
                            addCandidate: model.addCandidates,
                            nameFilter: model.filterCandidateName,
                            updateMenu: model.addCandidatesToMenu,
                            opacityValue: model.validIconOpacity,
                            actionSheetMessage: model.addedCandidateMessage())
                    case .numberOfVoter:
                        NumberOfVoters(
                            numberOfVoters: $model.numberOfVoters,
                            screen: $model.electionScreen,
                            maxVoters: model.maximumVoters)
                    case .votingBooth:
                        VotingBooth(
                            voterCompleted: $model.voterCompleted,
                            selectedCandidate: $model.voterPreference,
                            voterName: $model.voterName,
                            screen: $model.electionScreen,
                            doneVoting: $model.doneVoting,
                            disableVoterName: model.disableVoterName,
                            currentVoter: model.currentVoterNumber,
                            totalVoters: model.numberOfVoters,
                            filterName: model.filterVoterName,
                            dropMenuLabel: model.dropMenuLabel(),
                            candidateChoices: model.candidatesMenu,
                            candidateVotedFor: model.candidateVotedFor(),
                            voteButtonLabel: model.voteButtonLabel(),
                            voteButtonColor: model.voterPreferences.count == model.candidates.keys.count - 1 ? .green : .blue,
                            voteButtonAction: model.voteButtonAction,
                            submitVote: model.submitVote,
                            actionSheetTitle: model.actionSheetTitle(),
                            actionSheetMesage: model.actionSheetMessage(),
                            actionSheetReset: model.resetVoterChoice)
                    case .winner:
                        WinnerView(
                            winners: model.winners,
                            resetAction: model.resetElection)
                    }
                }.containerViewModifier(fontColor: .white, borderColor: .black)
                
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
