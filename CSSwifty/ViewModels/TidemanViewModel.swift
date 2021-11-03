//
//  TidemanViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 11/3/21.
//

import Foundation

class TidemanViewModel: ObservableObject {
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
    @Published var candidates: [String : Int] = [:]
    @Published var candidatesMenu: [String] = []
    @Published var voterPreferences: [String] = []
    @Published var votersChoices: [Int : [String]] = [:]
    
    
    let week: Weeks = .week3
    let problem: Problems = .tideman
    let maximumVoters = 50
    
    var candidateGraph = Graph<String>()
    var candidatePairs: [(first: String, second: String)] = []
    var winners: [String] = []
    
    let intro = [
        "In plurality, there can be a tie, and with runoff, sometimes the least favored candidate wins.",
        "The Tideman voting method (also known as “ranked pairs”) is a ranked-choice voting method that’s guaranteed to produce the Condorcet winner of the election if one exists.",
        "The Condorcet winner of the election is the person who would have won any head-to-head matchup against another candidate."
    ]
    
    let rules = [
        "No duplicate name for candidates.",
        "Maximum 9 candidates",
        "Maximum 50 voters",
        "All voters must vote for all their choices before the winner is declared."
    ]
    
    // Mark: - SETUP CODE
    
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
    
    // Function to update the vote count for candidates once they have been voted for.
    func castVote() {
        // find the current vote count of the candidate and increase it by 1
        let vote = (candidates[voterPreferences[0]] ?? 0) + 1
        
        // update the vote count of the candidate
        candidates.updateValue(vote, forKey: voterPreferences[0])
        
        // update the voter choices dictionary with the voter's choices
        votersChoices[currentVoterNumber] = voterPreferences
    }
    
    // Function for when each voter pressed vote in the voting booth screen
    func submitVote() {
        if currentVoterNumber < numberOfVoters {
            castVote()
            clearForNextVoter()
            currentVoterNumber += 1
            voterCompleted = false
        } else {
            castVote()
            clearForNextVoter()
            declareWinner()
            self.doneVoting.toggle()
        }
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
    
    // Mark: - PROBLEM ALGORITHM
 
    // create a dictionary of pairs
    func makeGraphPairs() {
        let pairs = candidates.keys.map { $0 }.combination(length: 2)
        for eachPair in pairs {
            candidatePairs.append((eachPair[0], eachPair[1]))
        }
    }
    
    // Function to calculate the head to head winner between candidates
    func headToHead(first: String, second: String) -> (source: String, destination: String, weight: Double) {
        var pairs = [first : 0, second : 0]
        var ballotForPairs: [Int : [String]] = [:]
        
        for (voterNumber, candidateChoices) in votersChoices {
            let newChoices = candidateChoices.filter { pairs.keys.contains($0) }
            ballotForPairs.updateValue(newChoices, forKey: voterNumber)
        }
        
        for preferences in ballotForPairs.values {
            let vote = (pairs[preferences[0]] ?? 0) + 1
            pairs.updateValue(vote, forKey: preferences[0])
        }
        
        let maxVote = pairs.values.reduce(Int.min, { max($0, $1) })
        let minVote = pairs.values.reduce(Int.max, { min($0, $1) })
        let winner = pairs.filter({ $0.value >= maxVote }).keys.joined()
        let loser = pairs.filter({ $0.value < maxVote }).keys.joined()
        let difference = Double(maxVote - minVote)
        
        return (winner, loser, difference)
    }
    
    // Function to construct the graph based on votes
    func assembleGraph() {
        makeGraphPairs()
        for (first, second) in candidatePairs {
            
            let firstCandidate =  headToHead(first: first, second: second).source
            let secondCandidate = headToHead(first: first, second: second).destination
            let weight = headToHead(first: first, second: second).weight
            
            let source = candidateGraph.createVertex(value: firstCandidate)
            let destination = candidateGraph.createVertex(value: secondCandidate)
            
            candidateGraph.addEdge(type: .directed, source: source, destination: destination, weight: weight)
        }
    }
    
    // function to delete the lowest weight in the graph
    func deleteLowestWeight() {
        if let minEdge = candidateGraph.lowestEdge() {
            candidateGraph.deleteEdge(edge: minEdge)
        }
    }
    
    // Function to determine the winner depending on cycle or not
    func determineWinner() -> [String] {
        return candidateGraph.allVertices().filter{ !candidateGraph.allEdges().contains($0) }.map { $0.description }
    }
    
    // Function to declare the winner
    func declareWinner() {
        assembleGraph()
        
        if candidateGraph.isCyclic {
            deleteLowestWeight()
            winners.append(contentsOf: determineWinner())
        } else {
            winners.append(contentsOf: determineWinner())
        }
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
    
    // Function for displaying the names of selected candidates in order on Action sheet
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
