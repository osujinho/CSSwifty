//
//  ProblemsThreeModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/26/21.
//

import SwiftUI

// -------------------------------- PLURALITY ---------------------------------------

// Back button and title stack
struct TitleAndBack: View {
    let action: () -> Void
    let title: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            IconButton(icon: "chevron.left", iconColor: .blue, action: action)
            Spacer()
            HeadlineLabel(label: title.uppercased())
                .foregroundColor(.yellow)
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
    @Binding var addStatus: ValidStatus
    @Binding var screen: ElectionScreen
    let addCandidate: Func
    let nameFilter: Func
    let updateMenu: Func
    let opacityValue: Double
    let actionSheetMessage: String
    
    var body: some View {
        VStack {
            // Title
            HeadlineLabel(label: "ADD CANDIDATES")
                .foregroundColor(.yellow)
                .padding(.bottom, 5)
            
            HStack {
                TextFieldInput(target: $candidateName, label: "Name", placeHolder: "Name of candidate", onChangeFunc: nameFilter)
            }
            .padding(.bottom, 10)
            
            HStack{
                LabelButton(
                    label: "Add " + candidateName,
                    bgColor: .blue,
                    action: {
                        addCandidate()
                        
                        if addStatus == .invalid {
                            withAnimation(.default) {
                                invalidShakeAmount += 1
                            }
                        } else {
                            validScaleAmount = 0.1
                            withAnimation(.easeInOut(duration: 1.0)) {
                                validScaleAmount += 1
                            }
                        }
                    },
                    isDisabled: candidateName.isEmpty)
                
                Spacer()
                
                // Calls the confirmation Action Sheet
                LabelButton(
                    label: "Proceed",
                    bgColor: .green,
                    action: { self.candidateConfirmation = true },
                    isDisabled: candidates.count < 2)
                
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
                title: Text("The added candidates are..."),
                message: Text(actionSheetMessage),
                buttons: [
                    .default(Text("Confirm Candidates")) {
                        updateMenu()
                        screen = .numberOfVoter
                    },
                    .destructive(Text("Reset Candidates"), action: {
                        candidates.removeAll()
                        candidateName.removeAll()
                    })
            ])
        }
    }
}

// -------------- Select Number of voters View -------------------
struct NumberOfVoters: View {
    @Binding var numberOfVoters: Int
    @Binding var screen: ElectionScreen
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleAndBack(
                action: { screen = .addCandidate },
                title: "Number of voters")
            
            HStack {
                NumericStepper(key: $numberOfVoters, maxValue: 10, label: "Number of Voters")
                
                Spacer()
                
                LabelButton(
                    label: "Proceed",
                    bgColor: .blue,
                    action: { screen = .votingBooth },
                    isDisabled: numberOfVoters == 0)
            }
        }
    }
}

// -------------------- Voting Booth Screen -------------------------------
struct VotingBooth: View {
    @Binding var voterCompleted: Bool
    @Binding var selectedCandidate: String
    @Binding var voterName: String
    @Binding var screen: ElectionScreen
    @Binding var doneVoting: Bool
    @State private var voteSuccessfulOpacity = 0.0
    
    let disableVoterName: Bool
    let currentVoter: Int
    let totalVoters: Int
    let filterName: Func
    let dropMenuLabel: String
    let candidateChoices: [String]
    let candidateVotedFor: String
    let voteButtonLabel: String
    let voteButtonColor: Color
    let voteButtonAction: Func
    let declareWinner: Func
    let submitVote: Func
    let actionSheetTitle: String
    let actionSheetMesage: String
    let actionSheetReset: Func
    
    var body: some View {
        VStack{
            // Title of Stack
            TitleAndBack(
                action: { screen = .numberOfVoter },
                title: "Voting Booth")
            
            // The voter's number and name
            HStack(alignment: .bottom) {
                HeadlineLabel(label: "Voter")
                Text("\(currentVoter) of \(totalVoters)")
                
                Spacer(minLength: 40)
                
                TextFieldInput(target: $voterName, label: "Name", placeHolder: "Enter your name", onChangeFunc: filterName)
                    .opacity(disableVoterName ? 0.6 : 1.0)
                    .disabled(disableVoterName)
            }
            
            Spacer()
            
            // Candidates names
            HStack {
                HeadlineLabel(label: dropMenuLabel)
                
                DropDownMenu(selection: $selectedCandidate, collection: candidateChoices, label: "Select...")
                
                IconButton(
                    icon: "trash",
                    iconColor: .red,
                    action: { selectedCandidate.removeAll() },
                    isDisabled: selectedCandidate.isEmpty)
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            // Voted Text and vote button
            HStack {
                // Vote button
                LabelButton(
                    label: voteButtonLabel,
                    bgColor: voteButtonColor,
                    action: { voteButtonAction() },
                    isDisabled: selectedCandidate.isEmpty || voterName.isEmpty)
                
                Spacer()
                
                // Text displaying selected choice
                HeadlineLabel(label: candidateVotedFor)
                    .foregroundColor(.yellow)
                    .shadow(color: .green, radius: 10)
                    .opacity(voteSuccessfulOpacity)
            }
        }
        .alert(isPresented: $doneVoting) {
            Alert(
                title: Text("Counting Votes"),
                message: Text("Everyone has voted, we are counting the votes..."),
                dismissButton: .default(Text("Show Result")) {
                    declareWinner()
                })
        }
        .actionSheet(isPresented: $voterCompleted) {
            ActionSheet(
                title: Text(actionSheetTitle),
                message: Text( actionSheetMesage ),
                buttons: [
                    .default(Text("Submit")) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            voteSuccessfulOpacity += 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            submitVote()
                            voteSuccessfulOpacity -= 1
                        })
                    },
                    .destructive(Text("Reset"), action: {
                        actionSheetReset()
                    })
            ])
        }
    }
}

// Winner View
struct WinnerView: View {
    @State private var winnerOpacity = 0.0
    @State private var votesOpacity = 0.0
    @State private var scaleValue: CGFloat = 0.1
    
    let winners: [String]
    let winningVoteCount: Int
    let resetAction: () -> Void
    
    var body: some View {
        VStack {
            Text(winners.count < 2 ? "And the winner is..." : "The winners are...")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            VStack {
                ForEach(winners, id: \.self) { winner in
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
            
            if winners.count > 1 {
                Text("In a \(winners.count)-way tie!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .opacity(votesOpacity)
                    .padding(.bottom, 3)
            }
            
            Text(winners.count < 2 ? "With \(winningVoteCount) votes!" : "With \(winningVoteCount) votes each!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
                .opacity(votesOpacity)
            
            Divider()
            
            LabelButton(label: "Continue", bgColor: .green, action: resetAction)
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
