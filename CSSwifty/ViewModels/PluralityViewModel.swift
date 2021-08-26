//
//  PluralityViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/26/21.
//

import Foundation

class PluralityViewModel: ObservableObject {
    @Published var numberOfVoters = 0
    @Published var currentVoterNumber = 1
    @Published var voterName = ""
    @Published var addStatus: ValidStatus?
    @Published var electionScreen: ElectionScreen = .addCandidate
    @Published var doneVoting = false
    @Published var nameOfCandidate = ""
    @Published var candidateVotingFor = ""
    @Published var validIconOpacity = 0.0
    @Published var candidates = [String : Int]()
    
    var winners = [String]()
    var winningVoteCount = 0
    let week: Weeks = .week3
    let problem: Problems = .plurality
    
    let intro = [
        "Plurality is a type of election in which the winner takes all.",
        "Every voter gets to vote for only one candidate.",
        "At the end of the election, whichever candidate has the greatest number of votes wins the election."
    ]
    
    let rules = [
        "No duplicate name for candidates.",
        "Maximum 9 candidates",
        "Maximum 50 voters",
        "All voters must vote before the winner is declared."
    ]
    
    // Function to add candidates to the dictionary
    func addCandidates() {
        if candidates.keys.contains(nameOfCandidate.capitalized) {
            invalidCandidateName()
        } else {
            validCandidateName()
        }
    }
    
    // Function to declare the winner
    func declareWinner() {
        winningVoteCount = candidates.reduce(0) { max($0, $1.1) }
        for (key, value) in candidates {
            if value == winningVoteCount {
                winners.append(key)
            }
        }
        switchScreen(screen: .winner)
    }
    
    // Function to update the vote count for candidates once they have been voted for.
    func updateCandidateVote() {
        let vote = (candidates[candidateVotingFor] ?? 0) + 1
        candidates.updateValue(vote, forKey: candidateVotingFor)
    }
    
    // Function for when vote is pressed in the voting booth screen
    func submitVote() {
        if currentVoterNumber < numberOfVoters {
            updateCandidateVote()
            clearSelections()
            currentVoterNumber += 1
        } else {
            updateCandidateVote()
            clearSelections()
            self.doneVoting.toggle()
        }
    }
    
    // Function to switch screens
    func switchScreen(screen: ElectionScreen) {
        self.electionScreen = screen
    }
    
    // Function for when candidate name is invalid and not added
    func invalidCandidateName() {
        addStatus = .invalid
        validIconOpacity = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.nameOfCandidate = ""
            self.validIconOpacity = 0.0
        })
    }
    
    // Function for when candidate name is valid and added
    func validCandidateName() {
        candidates[nameOfCandidate.capitalized] = 0
        addStatus = .valid
        validIconOpacity = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.nameOfCandidate = ""
            self.validIconOpacity = 0.0
        })
    }
    
    // Function for when clear is pressed on the voting booth screen
    func clearSelections() {
        voterName = ""
        candidateVotingFor = ""
    }
    
    // Function to reset the election at the end
    func resetElection() {
        numberOfVoters = 0
        currentVoterNumber = 1
        nameOfCandidate = ""
        voterName = ""
        winners.removeAll()
        candidates.removeAll()
        switchScreen(screen: .addCandidate)
    }
    
    // Function to ensure candidate name does not contain numbers
    func filterCandidateName() {
        for letter in nameOfCandidate {
            if letter.isNumber {
                nameOfCandidate.removeLast()
            }
        }
    }
    
    // Function to ensure voter's name does not contain numbers
    func filterVoterName() {
        for letter in voterName {
            if letter.isNumber {
                voterName.removeLast()
            }
        }
    }
}

enum ElectionScreen: Identifiable {
    case addCandidate, numberOfVoter, votingBooth, winner
    
    var id: ElectionScreen { self }
}
