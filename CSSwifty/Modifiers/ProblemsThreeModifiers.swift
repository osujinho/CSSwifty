//
//  ProblemsThreeModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/26/21.
//

import SwiftUI

// -------------------------------- PLURALITY ---------------------------------------

// ------------ Add candidate View -----------------
struct AddCandidate: View {
    @EnvironmentObject var model: PluralityViewModel
    @State private var invalidShakeAmount = 0.0
    @State private var validScaleAmount = 1.0
    @State private var iconOpacity = 0.0
    
    var body: some View {
        VStack {
            HStack {
                TextFieldInput(target: $model.nameOfCandidate, label: "Add Candidate", placeHolder: "Name of candidate", onChangeFunc: model.filterCandidateName)
                
                // Delete button to remove all candidates
                Button(action: {model.candidates.removeAll()}, label: {})
                    .buttonStyle(IconButtonStyle(iconName: "trash", iconColor: .red))
                    .opacity(model.candidates.isEmpty ? 0.5 : 1.0)
                    .disabled(model.candidates.isEmpty)
            }
            HStack{
                Button(action: {
                    model.addCandidates()
                    
                    if model.addStatus == .invalid {
                        withAnimation(.default) {
                            invalidShakeAmount += 1
                        }
                    } else {
                        validScaleAmount = 0.0
                        withAnimation(.easeInOut(duration: 1.0)) {
                            validScaleAmount += 1
                        }
                    }
                }) {
                    Text("Add " + model.nameOfCandidate)
                        .singleButtonModifier(fontSize: 15, bgColor: .blue, verticalPadding: 10, horizontalPadding: 20, radius: 10)
                        .opacity(model.nameOfCandidate.isEmpty ? 0.5 : 1.0)
                }.disabled(model.nameOfCandidate.isEmpty)
                
                Spacer()
                
                Button(action: {
                    model.switchScreen(screen: .numberOfVoter)
                }) {
                    Text("Proceed")
                        .singleButtonModifier(fontSize: 15, bgColor: .blue, verticalPadding: 10, horizontalPadding: 20, radius: 10)
                        .opacity(model.candidates.count < 2 ? 0.2 : 1.0)
                }.disabled(model.candidates.count < 2)
                
                
                Image(systemName: model.addStatus == .valid ? "checkmark" : "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(model.addStatus == .valid ? (Color.green.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)) : (Color.red.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)))
                    .opacity(model.validIconOpacity)
                
            }
            Text(model.addStatus == .valid ? model.nameOfCandidate + " added!" : model.nameOfCandidate + " already exists!")
                .foregroundColor(model.addStatus == .valid ? .green : .red)
                .opacity(model.validIconOpacity)
                .scaleEffect(CGFloat(validScaleAmount))
        }
        .modifier(Shake(animatableData: CGFloat(invalidShakeAmount)))
    }
}

// -------------- Select Number of voters View -------------------
struct NumberOfVoters: View {
    @EnvironmentObject var model: PluralityViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {model.switchScreen(screen: .addCandidate)}, label: {}).buttonStyle(IconButtonStyle(iconName: "chevron.left", iconColor: .blue))
            
            HStack {
                NumericStepper(key: $model.numberOfVoters,maxValue: 10, label: "Number of Voters")
                
                Spacer()
                
                Button(action: {
                    model.switchScreen(screen: .votingBooth)
                }, label: {
                    Text("Proceed")
                        .singleButtonModifier(fontSize: 15, bgColor: .blue, verticalPadding: 10, horizontalPadding: 15, radius: 10)
                        .opacity(model.numberOfVoters == 0 ? 0.5 : 1.0)
                }).disabled(model.numberOfVoters == 0)
            }
        }
    }
}

// -------------------- Voting Booth Screen -------------------------------
struct VotingBooth: View {
    @EnvironmentObject var model: PluralityViewModel
    @State private var voteConfirmation = false
    @State private var voteSuccessfulOpacity = 0.0
    
    var body: some View {
        VStack{
            // Title of Stack
            HStack {
                Button(action: {model.switchScreen(screen: .numberOfVoter)}, label: {}).buttonStyle(IconButtonStyle(iconName: "chevron.left", iconColor: .blue))
                Spacer()
                Text("Voting Booth")
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 5)
            
            // The voter's number and name
            HStack {
                Text("Voter Number: ")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("\(model.currentVoterNumber) of \(model.numberOfVoters)")
                Spacer()
            }
            
            TextFieldInput(target: $model.voterName, label: "Name", placeHolder: "Enter your name", onChangeFunc: model.filterVoterName)
            
            Spacer()
            
            HStack {
                Text("Candidate Name: ")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                DropDownMenu(selection: $model.candidateVotingFor, collection: Array(model.candidates.keys), label: "Select...")
                Spacer()
            }
            
            HStack {
                ClearOrSubmitButton(icon: "xmark", buttonAction: model.clearSelections, isDisabled: model.voterName.isEmpty && model.candidateVotingFor.isEmpty, bgColor: .red, paddingValue: 10)
                
                Spacer()
                Text(model.voterName + " has voted for " + model.candidateVotingFor + "!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.yellow)
                    .shadow(color: .green, radius: 10)
                    .opacity(voteSuccessfulOpacity)
                
                Spacer()
                Button(action: {
                    self.voteConfirmation = true
                }, label: {
                    Text("Vote")
                        .singleButtonModifier(fontSize: 15, bgColor: .green, verticalPadding: 10, horizontalPadding: 20, radius: 10)
                        .opacity(model.candidateVotingFor.isEmpty && model.voterName.isEmpty ? 0.5 : 1.0)
                }).disabled(model.candidateVotingFor.isEmpty && model.voterName.isEmpty)
            }
        }
        .alert(isPresented: $model.doneVoting) {
            Alert(
                title: Text("Counting Votes"),
                message: Text("Everyone has voted, we are counting the votes..."),
                dismissButton: .default(Text("Show Result")) {
                    model.declareWinner()
                })
        }
        .actionSheet(isPresented: $voteConfirmation) {
            ActionSheet(
                title: Text("Confirm Vote"),
                message: Text(model.voterName + " are you sure you want to vote for " + model.candidateVotingFor + "?"),
                buttons: [
                    .default(Text("Confirm Vote for " + model.candidateVotingFor)) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            voteSuccessfulOpacity += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            model.submitVote()
                            voteSuccessfulOpacity -= 1
                        })
                    },
                    .cancel()
            ])
        }
    }
}

// Winner View
struct WinnerView: View {
    @EnvironmentObject var model: PluralityViewModel
    @State private var winnerOpacity = 0.0
    @State private var votesOpacity = 0.0
    @State private var scaleValue: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Text(model.winners.count < 2 ? "And the winner is..." : "The winners are...")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            VStack {
                ForEach(model.winners, id: \.self) { winner in
                    Text(winner)
                        .fontWeight(.bold)
                }
            }
            .font(.title)
            .foregroundColor(.yellow)
            .shadow(color: .green, radius: 30 / 3, x: -10, y: 10)
            .shadow(color: .pink, radius: 30 / 3, x: 0, y: -10)
            .shadow(color: .blue, radius: 30 / 3, x: 10, y: 10)
            .padding(.vertical, 10)
            .scaleEffect(scaleValue)
            .opacity(winnerOpacity)
            
            if model.winners.count > 1 {
                Text("In a \(model.winners.count)-way tie!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .opacity(votesOpacity)
                    .padding(.bottom, 3)
            }
            
            Text(model.winners.count < 2 ? "With \(model.winningVoteCount) votes!" : "With \(model.winningVoteCount) votes each!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
                .opacity(votesOpacity)
            
            Divider()
            Button(action: {
                model.resetElection()
            }, label: {
                Text("Continue")
                    .singleButtonModifier(fontSize: 15, bgColor: .green, verticalPadding: 10, horizontalPadding: 20, radius: 10)
            })
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                withAnimation(.easeInOut(duration: 2.0)) {
                    winnerOpacity += 1
                    scaleValue += 1
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                withAnimation(.easeInOut(duration: 2.0)) {
                    votesOpacity += 1
                }
            })
        }
    }
}
