//
//  ProblemsThreeModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/26/21.
//

import SwiftUI

// -------------------------------- PLURALITY ---------------------------------------

struct TitleAndBack: View {
    let screen: ElectionScreen
    let switchScreen: (ElectionScreen) -> ()
    let title: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {switchScreen(screen)}, label: {}).buttonStyle(IconButtonStyle(iconName: "chevron.left", iconColor: .blue))
            Spacer()
            Text(title.uppercased())
                .font(.headline)
                .foregroundColor(.yellow)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.bottom, 5)
    }
}

// ------------ Add candidate View -----------------
struct AddCandidate: View {
    @State private var invalidShakeAmount = 0.0
    @State private var validScaleAmount = 1.0
    @State private var candidateConfirmation = false
    
    @Binding var candidates: [String : Int]
    @Binding var candidateName: String
    let addCandidate: Func
    let nameFilter: Func
    let addStatus: ValidStatus
    let updateMenu: Func
    let opacityValue: Double
    
    var body: some View {
        VStack {
            // Title
            Text("ADD CANDIDATES")
                .font(.headline)
                .foregroundColor(.yellow)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            HStack {
                TextFieldInput(target: $candidateName, label: "Name", placeHolder: "Name of candidate", onChangeFunc: nameFilter)
                
                // Delete button to remove all candidates
                Button(action: {candidates.removeAll()}, label: {})
                    .buttonStyle(IconButtonStyle(iconName: "trash", iconColor: .red))
                    .opacity(candidates.isEmpty ? 0.5 : 1.0)
                    .disabled(candidates.isEmpty)
            }
            .padding(.bottom, 10)
            
            HStack{
                Button(action: {
                    addCandidate()
                    
                    if addStatus == .invalid {
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
                    Text("Add " + candidateName)
                        .singleButtonModifier(fontSize: 15, bgColor: .blue, verticalPadding: 10, horizontalPadding: 20, radius: 10)
                        .opacity(candidateName.isEmpty ? 0.5 : 1.0)
                }.disabled(candidateName.isEmpty)
                
                Spacer()
                
                // Calls the confirmation Action Sheet
                Button(action: {
                    self.candidateConfirmation = true
                }) {
                    Text("Proceed")
                        .singleButtonModifier(fontSize: 15, bgColor: .green, verticalPadding: 10, horizontalPadding: 20, radius: 10)
                        .opacity(candidates.count < 2 ? 0.2 : 1.0)
                }.disabled(candidates.count < 2)
                
                
                Image(systemName: addStatus == .valid ? "checkmark" : "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(addStatus == .valid ? (Color.green.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)) : (Color.red.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)))
                    .opacity(opacityValue)
                
            }
            
            Text(addStatus == .valid ? candidateName + " added!" : candidateName + " already exists!")
                .foregroundColor(addStatus == .valid ? .green : .red)
                .opacity(opacityValue)
                .scaleEffect(CGFloat(validScaleAmount))
        }
        .modifier(Shake(animatableData: CGFloat(invalidShakeAmount)))
        .actionSheet(isPresented: $candidateConfirmation) {
            ActionSheet(
                title: Text("Confirm Candidates"),
                message: Text("""
                    The added candidates are...
                    \(candidates.keys.joined(separator: "\n"))
                    """),
                buttons: [
                    .default(Text("Confirm Candidates")) {
                        updateMenu()
                    },
                    .destructive(Text("Reset Candidates"), action: {
                        candidates.removeAll()
                    })
            ])
        }
    }
}

// -------------- Select Number of voters View -------------------
struct NumberOfVoters: View {
    @Binding var numberOfVoters: Int
    let switchScreen: (ElectionScreen) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TitleAndBack(screen: .addCandidate, switchScreen: switchScreen, title: "How many Voters")
            
            HStack {
                NumericStepper(key: $numberOfVoters, maxValue: 10, label: "Number of Voters")
                
                Spacer()
                
                Button(action: {
                    switchScreen(.votingBooth)
                }, label: {
                    Text("Proceed")
                        .singleButtonModifier(fontSize: 15, bgColor: .blue, verticalPadding: 10, horizontalPadding: 15, radius: 10)
                        .opacity(numberOfVoters == 0 ? 0.5 : 1.0)
                }).disabled(numberOfVoters == 0)
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
                ClearOrSubmitButton(
                    icon: "xmark",
                    buttonAction: model.clearSelections,
                    isDisabled: model.voterName.isEmpty && model.candidateVotingFor.isEmpty,
                    bgColor: .red,
                    paddingValue: 10)
                
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
