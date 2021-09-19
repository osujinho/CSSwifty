//
//  RunoffViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 9/19/21.
//

import Foundation

class RunoffViewModel: ObservableObject {
    @Published var numberOfVoters = 0
    @Published var currentVoterNumber = 1
    @Published var voterName = ""
    @Published var disableVoterName = false
    @Published var voterCompleted = false
    @Published var addStatus: ValidStatus = .none
    @Published var electionScreen: ElectionScreen = .addCandidate
    @Published var doneVoting = false
    @Published var candidateName = ""
    @Published var voterPreference = ""
    @Published var chosenCandidate = ""
    @Published var validIconOpacity = 0.0
    @Published var candidates = [String : Int]()
    @Published var candidatesMenu = [String]()
    @Published var voterPreferences = [String]()
    @Published var votersChoices = [Int : [String]]()
    
    var winners = [String]()
    var winningVoteCount = 0
    let week: Weeks = .week3
    let problem: Problems = .runoff
    let maximumVoters = 50
    
    let intro = [
        "Runoff is a ranked-choice voting system, where candidates get to vote for more than one candidate.",
        "They rank he candidates in order of preference, and the candidate with more than 50% of the first preference vote is declared the winner.",
        "However, if no candidate has more than 50% of the vote, an “instant runoff” occurrs.",
        "The candidate with the fewest number of votes is eliminated and anyone who originally chose that candidate as their first preference, has their second preference considered."
    ]
    
    let rules = [
        "No duplicate name for candidates.",
        "Maximum 9 candidates",
        "Maximum 50 voters",
        "All voters must vote for all their choices before the winner is declared."
    ]
    
    //Mark: - PROBLEM ALGORITHM
    
    // Function to add candidates to the dictionary
    func addCandidates() {
        if candidates.keys.contains(candidateName.capitalized) {
            invalidCandidateName()
        } else {
            validCandidateName()
        }
    }
    
    /* Function to add candidates' names to the drop menu display
       called after confirming at the add candidate screen
    */
    func addCandidatesToMenu() {
        candidatesMenu.removeAll()
        candidatesMenu.append(contentsOf: candidates.keys)
    }
    
    // Function for when vote is pressed in the voting booth screen
    func submitVote() {
        if currentVoterNumber < numberOfVoters {
            castVote()
            clearForNextVoter()
            currentVoterNumber += 1
            voterCompleted = false
        } else {
            castVote()
            clearForNextVoter()
            self.doneVoting.toggle()
        }
    }
    
    // Function to update the vote count for candidates once they have been voted for.
    func castVote() {
        // find the current vote count of the candidate and increase it by 1
        let vote = (candidates[voterPreferences[0]] ?? 0) + 1
        
        // update the vote count of the candidate
        candidates.updateValue(vote, forKey: voterPreferences[0])
        
        // update the voter choices dictionary with the voter's choices
        votersChoices[currentVoterNumber] = voterPreferences
    }
    
    // Function to eliminate the candidates with the lowest preference votes
    func eliminationRunoff() {
        let minVotes = candidates.values.reduce(Int.max, { min($0, $1) })
        let minCandidate = candidates.keys.filter { candidates[$0] == minVotes }.joined()
        candidates.removeValue(forKey: minCandidate)
        updateVote()
    }
    
    // Recounts the vote after elimination in runoff
    func updateVote() {
        // resets the dictionary to zero
        candidates.keys.forEach { candidates[$0] = 0 }
        
        // Recounts the votes
        for preferences in votersChoices.values {
            if let preference = preferences.first( where: {candidates.keys.contains($0)} ) {
                let vote = candidates[preference] ?? 0
                candidates.updateValue(vote + 1, forKey: preference)
            }
        }
    }
    
    // Function to declare the winner
    func declareWinner() {
        var maxVote = candidates.values.reduce(Int.min, { max($0, $1) })
        
        if maxVote > (votersChoices.count / 2) {
            winners.append(contentsOf: candidates.filter { $0.value >= maxVote }.keys)
            winningVoteCount = maxVote
        } else {
            while maxVote <= votersChoices.count / 2 {
                eliminationRunoff()
                maxVote = candidates.values.reduce(Int.min, { max($0, $1) })
            }
            winners.append(contentsOf: candidates.filter { $0.value >= maxVote }.keys)
            winningVoteCount = maxVote
        }
        electionScreen = .winner
    }
    
    // Function to reset the election at the end
    func resetElection() {
        numberOfVoters = 0
        currentVoterNumber = 1
        candidateName = ""
        voterName = ""
        winners.removeAll()
        candidates.removeAll()
        electionScreen = .addCandidate
    }
    
    //Mark: - ADD CANDIDATE SCREEN
    
    // Function to ensure candidate name does not contain numbers
    func filterCandidateName() {
        for letter in candidateName {
            if letter.isNumber {
                candidateName.removeLast()
            }
        }
    }
    
    // Function for when candidate name is invalid and not added
    func invalidCandidateName() {
        addStatus = .invalid
        validIconOpacity = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.candidateName = ""
            self.validIconOpacity = 0.0
        })
    }
    
    // Function for when candidate name is valid and added
    func validCandidateName() {
        candidates[candidateName.capitalized] = 0
        addStatus = .valid
        validIconOpacity = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.candidateName = ""
            self.validIconOpacity = 0.0
        })
    }
    
    // Function to display the added candidate action sheet message
    func addedCandidateMessage() -> String {
        var order = 1
        var names = [String]()
        for candidate in candidates.keys {
            names.append("\(order). " + candidate)
            order += 1
        }
        return "\n" + names.joined(separator: "\n")
    }
    
    //Mark: - VOTING BOOTH
    
    // Function to ensure voter's name does not contain numbers
    func filterVoterName() {
        for letter in voterName {
            if letter.isNumber {
                voterName.removeLast()
            }
        }
    }
    
    // Function to clear selections on the voting booth screen
    // Function to reset so that next voter can cast their vote
    func clearForNextVoter() {
        voterPreferences.removeAll()
        addCandidatesToMenu()
        voterName = ""
        voterPreference = ""
        chosenCandidate = ""
        disableVoterName = false
    }
    
    // Function to update the chandidates menu after a selection
    func updateMenu() {
        if candidatesMenu.contains(voterPreference) {
            candidatesMenu.removeAll { $0 == voterPreference }
            voterPreference.removeAll()
            disableVoterName = true
        }
    }
    
    // func to add candidates to selection order array
    func addToPreferences() {
        voterPreferences.append(voterPreference)
        updateMenu()
    }
    
    // Function for when the vote button is pressed
    func voteButtonAction() {
        switch voterPreference {
        case _ where (voterPreferences.count == candidates.keys.count - 1):
            addToPreferences()
            chosenCandidate = voterPreferences[0]
            voterCompleted = true
        default: addToPreferences()
        }
    }
    
    // Function to reset the current voter's choices
    func resetVoterChoice() {
        voterPreferences.removeAll()
        addCandidatesToMenu()
        chosenCandidate = ""
    }
    
    //Mark: - STRINGS
    
    // Function to return string for candidate voted for
    func candidateVotedFor() -> String {
        return voterName.capitalized + " has voted for " + chosenCandidate + "!"
    }
    
    // Function to display the label next to the drop down menu
    func dropMenuLabel() -> String {
        switch voterPreferences{
        case _ where voterPreferences.isEmpty:
            return "Preferred Candidate:"
        case _ where candidatesMenu.isEmpty:
            return "\((voterPreferences.count).toOrdinal) choice"
        default:
            return "\((voterPreferences.count + 1).toOrdinal) choice"
        }
    }
    
    // Function for the vote button Label on voting booth
    func voteButtonLabel() -> String {
        switch voterPreferences {
        case _ where (voterPreferences.isEmpty):
            return "Vote"
        case _ where (voterPreferences.count == candidates.keys.count - 1):
            return "Add and Submit"
        default: return "Add"
        }
    }
    
    // function to display the action sheet title
    func actionSheetTitle() -> String {
        return voterName.capitalized + " please confirm the candidates in order of your preference."
    }
    
    // Function for displaying the names of candidates in order on Action sheet
    func actionSheetMessage() -> String {
        var order = 1
        var names = [String]()
        for candidate in voterPreferences {
            if order == 1 {
                names.append("\(order). " + candidate + " - Preferred Candidate")
                order += 1
            } else {
                names.append("\(order). " + candidate + " - \(order.toOrdinal) choice")
                order += 1
            }
        }
        return "\n" + names.joined(separator: "\n")
    }
    
    
    
}
